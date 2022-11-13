package com.o2a4.chattcp.service;

import com.o2a4.chattcp.model.Seats;
import com.o2a4.chattcp.proto.TransferOuterClass;
import com.o2a4.chattcp.repository.ChannelIdChannelRepository;
import com.o2a4.chattcp.repository.TrainChannelGroupRepository;
import io.netty.channel.Channel;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.stereotype.Component;
import com.o2a4.chattcp.proto.TransferOuterClass.Transfer;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Slf4j
@Service
@RequiredArgsConstructor
public class RoomService {
    private final ReactiveRedisTemplate<String, String> redisTemplate;
    private final TrainChannelGroupRepository tcgRepo;
    private final ChannelIdChannelRepository cidcRepo;


    static String uPrefix = "user:";
    static String tPrefix = "train:";
    static String sPrefix = "server:";
    static String cPrefix = "channel:";

    public void roomIn(Channel channel, Transfer trans) {
        String userId = trans.getUserId();
        // TODO 빌런 숫자 입장할때 content에 넣어서 보내주기
        // TODO 채팅 입장 로직 수정?
        redisTemplate.opsForHash().get("user:" + userId, "channelGroup")
                .flatMap(
                        cg -> {
                            String channelId = channel.id().asShortText();

                            // 열차 채팅방에 채널 추가
                            tcgRepo.getTrainChannelGroupMap().get(cg).add(channel);
                            // 채널Id 채널 맵에 추가
                            cidcRepo.getChannelIdChannelMap().put(channelId, channel);

                            return redisTemplate.opsForHash().put(uPrefix + userId, "channel", channelId)
                                    .doOnSubscribe(i -> {
                                        log.info("ROOM IN MESSAGE SENDING");
                                        tcgRepo.getTrainChannelGroupMap().get(cg).writeAndFlush(trans);
                                    }
                            );
//                            return redisTemplate.opsForValue().set(cPrefix + channelId, userId).flatMap(i -> {})
                        })
                .subscribe();
    }

    public void roomOut(Channel channel, Transfer trans) {
        // TODO 여기 로직을 전체적으로 구조를 수정해서 Channel이 생성되거나 없어졌을 때 처리하도록 바꾸는게 좋을듯
        // FutureListener, REST도 다시 정리하기
        String userId = trans.getUserId();
        String channelId = channel.id().asShortText();

        redisTemplate.opsForHash().get("user:" + userId, "channelGroup")
            .flatMap(cg -> {
                // 채널Id 채널 맵에서 제거
                cidcRepo.getChannelIdChannelMap().remove(channelId);

                // 열차 채팅방에서 채널 제거 (close하면 알아서 channelGroup에서 제거됨)
                channel.close();

                return redisTemplate.opsForHash().delete(uPrefix+userId).doOnSubscribe(
                        i -> {
                            log.info("ROOM OUT MESSAGE SENDING");
                            tcgRepo.getTrainChannelGroupMap().get(cg).writeAndFlush(trans);
                        }
                );

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
        return res;}

    public void seatEnd(Transfer trans) {
        // TODO 자리양도 끝
    }

    public void villainOn(Transfer trans) {
        redisTemplate.opsForHash().get("user:" + trans.getUserId(), "channelGroup")
                .subscribe(cg -> {
                    redisTemplate.opsForHash().increment("train:" + (String) cg, "villain", 1).subscribe();
                    tcgRepo.getTrainChannelGroupMap().get(cg).writeAndFlush(trans);
                });
    }

    public void villainOff(TransferOuterClass.Transfer trans) {
        redisTemplate.opsForHash().get("user:" + trans.getUserId(), "channelGroup")
                .subscribe(cg -> {
                    redisTemplate.opsForHash().get("train:" + (String) cg, "villain")
                            .flatMap(num ->
                                    redisTemplate.opsForHash().put("train:" + (String) cg, "villain", Integer.valueOf((String) num) - 1))
                            .subscribe();

                    tcgRepo.getTrainChannelGroupMap().get(cg).writeAndFlush(trans);
                });
    }
}
