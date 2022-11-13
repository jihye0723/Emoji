package com.o2a4.chattcp.service;

import com.o2a4.chattcp.model.Seats;
import com.o2a4.chattcp.proto.TransferOuterClass;
import com.o2a4.chattcp.proto.TransferOuterClass.Transfer;
import com.o2a4.chattcp.repository.ChannelIdChannelRepository;
import com.o2a4.chattcp.repository.TrainChannelGroupRepository;
import io.netty.channel.Channel;
import io.netty.channel.group.ChannelGroup;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;

@Slf4j
@Service
@RequiredArgsConstructor
public class RoomService {
    private final ReactiveRedisTemplate<String, String> redisTemplate;
    private final TrainChannelGroupRepository tcgRepo;
    private final ChannelIdChannelRepository cidcRepo;
    private final MessageService messageService;


    static String uPrefix = "user:";
    static String tPrefix = "train:";
    static String sPrefix = "server:";
    static String cPrefix = "channel:";

    public void roomIn(Channel channel, Transfer trans) {
        String userId = trans.getUserId();
        redisTemplate.opsForHash().get("user:" + userId, "channelGroup")
                .flatMap(
                        cg -> {
                            String channelId = channel.id().asShortText();

                            // 열차 채팅방에 채널 추가
                            tcgRepo.getTrainChannelGroupMap().get(cg).add(channel);
                            // 채널Id 채널 맵에 추가
                            cidcRepo.getChannelIdChannelMap().put(channelId, channel);

                            return redisTemplate.opsForHash().get(tPrefix + cg, "villain")
                                    .flatMap(v -> {
                                        // Content에 빌런 수 전달
                                        Transfer send = Transfer.newBuilder(trans).setContent(v.toString()).build();

                                        return redisTemplate.opsForHash().put(uPrefix + userId, "channel", channelId)
                                                .doOnSubscribe(i -> {
                                                            log.info("ROOM IN MESSAGE SENDING");
                                                            tcgRepo.getTrainChannelGroupMap().get(cg).writeAndFlush(send);
                                                        }
                                                );
                                    });
//                            return redisTemplate.opsForValue().set(cPrefix + channelId, userId).flatMap(i -> {})
                        })
                .subscribe();
    }

    public void roomOut(Channel channel, Transfer trans) {
        String userId = trans.getUserId();
        String channelId = channel.id().asShortText();

        redisTemplate.opsForHash().get("user:" + userId, "channelGroup")
                .flatMap(cg -> {
                    // 채널Id 채널 맵에서 제거
                    cidcRepo.getChannelIdChannelMap().remove(channelId);
                    // 열차 채팅방에서 채널 제거 (close하면 알아서 channelGroup에서 제거됨)
                    channel.close();

                    ChannelGroup channelGroup = tcgRepo.getTrainChannelGroupMap().get(cg);
                    if (channelGroup != null && channelGroup.size() == 0) {
                        log.info("REMOVE TRAIN {} SERVER", cg);
                        // 메모리에서 채널그룹 제거
                        tcgRepo.getTrainChannelGroupMap().remove(cg);
                    } else {
                        log.info("ROOM OUT MESSAGE SENDING");
                        channelGroup.writeAndFlush(trans);
                    }

                    return redisTemplate.opsForHash().delete(uPrefix + userId);
                }).subscribe();
    }

    public Mono<String> seatStart(String userId) {
        // TODO 자리양도 시작
//         userId : 자리양도 시작한 사용자 아이디
        WebClient webClient = WebClient.create();
        Mono<String> res = webClient.get().uri("http://localhost:8082/seat/" + userId)
                .retrieve().bodyToMono(String.class);

//        RestTemplate restTemplate = new RestTemplate();
//        String res= restTemplate.getForObject("http://localhost:8082/seat/"+userId, String.class);
        return res;
    }

    public void seatEnd(Seats seat) {
        String userId = seat.getUserId();
        String winnerId = seat.getWinnerId();
        // 위치 정보에서 비속어 필터링
        String place = messageService.filterMessage(seat.getContent());
        String time = LocalDateTime.now().toString();

        Transfer.Builder builder = Transfer.newBuilder();

        builder.setType("seat-win");
        builder.setContent(place);
        builder.setUserId(userId);
        builder.setSendAt(time);

        // 당첨자 메시지 전송
        messageService.sendMessageToOne(builder.build(), winnerId);

        Transfer.Builder b2 = Transfer.newBuilder(builder.build())
                .setType("seat-end")
                .setContent("");

        // 채팅방 전체 메시지 전송
        messageService.sendMessageToRoom(b2.build(), "userId", userId);
    }

    public void villainOn(Transfer trans) {
        redisTemplate.opsForHash().get(uPrefix + trans.getUserId(), "channelGroup")
                .flatMap(cg ->
                        redisTemplate.opsForHash().increment(tPrefix + cg, "villain", 1)
                                .doOnSubscribe(incre -> {
                                    Transfer send = Transfer.newBuilder(trans).setContent(incre.toString()).build();
                                    // 빌런 증가하면 증가한 숫자를 전송
                                    tcgRepo.getTrainChannelGroupMap().get(cg).writeAndFlush(send);
                                })
                ).subscribe();
    }

    public void villainOff(TransferOuterClass.Transfer trans) {
        redisTemplate.opsForHash().get(uPrefix + trans.getUserId(), "channelGroup")
                .doOnSubscribe(cg ->
                        redisTemplate.opsForHash().get(tPrefix + cg, "villain")
                                .flatMap(num -> {
                                    int n = Integer.valueOf(String.valueOf(num));
                                    if (n == 0) {
                                        return Mono.empty();
                                    }

                                    Transfer send = Transfer.newBuilder(trans).setContent(String.valueOf(n - 1)).build();
                                    tcgRepo.getTrainChannelGroupMap().get(cg).writeAndFlush(send);

                                    return redisTemplate.opsForHash().put(tPrefix + cg, "villain", n - 1);
                                })
                )
                .subscribe();
    }
}
