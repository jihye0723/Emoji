package com.o2a4.chattcp.service;

import com.o2a4.chattcp.model.Seats;
import com.o2a4.chattcp.proto.TransferOuterClass;
import com.o2a4.chattcp.proto.TransferOuterClass.Transfer;
import com.o2a4.chattcp.repository.ChannelIdChannelRepository;
import com.o2a4.chattcp.repository.TrainChannelGroupRepository;
import io.netty.channel.Channel;
import io.netty.channel.ChannelFuture;
import io.netty.channel.group.ChannelGroup;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

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
        redisTemplate.opsForHash().get(uPrefix + userId, "channelGroup")
                .flatMap(
                        cg -> {
                            String channelId = channel.id().asShortText();

                            // 열차 채팅방에 채널 추가
                            tcgRepo.getTrainChannelGroupMap().get(cg).add(channel);
                            // 채널Id 채널 맵에 추가
                            cidcRepo.getChannelIdChannelMap().put(channelId, channel);
                            // 채널Id 유저id Redis에 저장
                            return redisTemplate.opsForValue().set(cPrefix + channelId, userId)
                                    .flatMap(i ->
                                            redisTemplate.expire(cPrefix + channelId, Duration.ofHours(3))
                                    ).flatMap(i ->
                                            redisTemplate.opsForHash().get(tPrefix + cg, "villain")
                                            .flatMap(v -> {
                                                // Content에 빌런 수 전달
                                                Transfer send = Transfer.newBuilder(trans).setContent(v.toString()).build();

                                                Map<String, String> aMap = new HashMap<>();
                                                aMap.put("channel", channelId);
                                                aMap.put("nickName", trans.getNickName());

                                                return redisTemplate.opsForHash().putAll(uPrefix + userId, aMap)
                                                        .doOnSubscribe(a -> {
                                                                    log.info("ROOM IN MESSAGE SENDING");
                                                                    tcgRepo.getTrainChannelGroupMap().get(cg).writeAndFlush(send);
                                                                }
                                                        );
                                            }));
//                            return redisTemplate.opsForValue().set(cPrefix + channelId, userId).flatMap(i -> {})
                        })
                .subscribe();
    }

    public void roomOut(Channel channel) {
        channel.close();
    }

    public Mono<String> seatStart(String userId) {
//         userId : 자리양도 시작한 사용자 아이디
        WebClient webClient = WebClient.create();
        Mono<String> res = webClient.get().uri("http://localhost:8082/seat/" + userId)
                .retrieve().bodyToMono(String.class);

        return res;
    }

    public void seatEnd(Seats seat) {
        log.info("자리 양도 종료 호출");
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
        // TODO 빌런 하나에 대한 중복 신고는 어떻게?
        redisTemplate.opsForHash().get(uPrefix + trans.getUserId(), "channelGroup")
                .flatMap(cg ->
                        redisTemplate.opsForHash().increment(tPrefix + cg, "villain", 1)
                                .flatMap(incre -> {
                                    log.info("SEND VILLAIN ON");
                                    Transfer.Builder send = Transfer.newBuilder(trans);
                                    send.setContent(incre.toString());
                                    send.build();
                                    // 빌런 증가하면 증가한 숫자를 전송
                                    tcgRepo.getTrainChannelGroupMap().get(cg).writeAndFlush(send);

                                    return Mono.empty();
                                })
                ).subscribe();
    }

    public void villainOff(Transfer trans) {
        redisTemplate.opsForHash().get(uPrefix + trans.getUserId(), "channelGroup")
                .flatMap(cg ->
                        redisTemplate.opsForHash().get(tPrefix + cg, "villain")
                                .flatMap(num -> {
                                    log.info("SEND VILLAIN OFF - num before : {}", num);

                                    int n = Integer.parseInt(String.valueOf(num));
                                    if (n == 0) {
                                        return Mono.empty();
                                    }

                                    Transfer send = Transfer.newBuilder(trans).setContent(String.valueOf(n - 1)).build();
                                    tcgRepo.getTrainChannelGroupMap().get(cg).writeAndFlush(send);

                                    return redisTemplate.opsForHash().put(tPrefix + cg, "villain", String.valueOf(n - 1));
                                })
                )
                .subscribe();
    }
}
