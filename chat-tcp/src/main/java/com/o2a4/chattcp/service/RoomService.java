package com.o2a4.chattcp.service;

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

    public void roomIn(Channel channel, Transfer trans) {
        // TODO 입장 처리 - Map에 채널ID, 채널 저장 & Redis에 유저-채널-채널id 저장
        String userId = trans.getUserId();

        redisTemplate.opsForHash().get("user:" + userId, "channelGroup")
            .flatMap(
                cg -> {
                    String channelId = channel.id().asShortText();

                    // 열차 채팅방에 채널 추가
                    tcgRepo.getTrainChannelGroupMap().get(cg).add(channel);
                    log.info("맵 배열 : {}", tcgRepo.getTrainChannelGroupMap().get(cg).toArray().toString());
                    // 채널Id 채널 맵에 추가
                    cidcRepo.getChannelIdChannelMap().put(channelId, channel);

                    return redisTemplate.opsForHash().put(uPrefix+userId, "channel", channelId).doOnSubscribe(
                        i -> {
                            log.info("ROOM IN MESSAGE SENDING");
                            tcgRepo.getTrainChannelGroupMap().get(cg).writeAndFlush(trans);
                        }
                    );
                })
                .subscribe();
    }

    public void roomOut(Channel channel, Transfer trans) {
        String userId = trans.getUserId();

        redisTemplate.opsForHash().get("user:" + userId, "channelGroup")
                .flatMap(
                        cg -> {
                            String channelId = channel.id().asShortText();

                            // 열차 채팅방에서 채널 제거
                            log.info("BEFORE MAP SIZE : {}",tcgRepo.getTrainChannelGroupMap().get(cg).toArray().length);
                            channel.close();
                            log.info("AFTER MAP SIZE : {}",tcgRepo.getTrainChannelGroupMap().get(cg).toArray().length);
//                            tcgRepo.getTrainChannelGroupMap().get(cg);
                            // 채널Id 채널 맵에 추가
                            cidcRepo.getChannelIdChannelMap().remove(channelId);

                            return redisTemplate.opsForHash().put(uPrefix+userId, "channel", channelId).doOnSubscribe(
                                    i -> {
                                        log.info("ROOM IN MESSAGE SENDING");
                                        tcgRepo.getTrainChannelGroupMap().get(cg).writeAndFlush(trans);
                                    }
                            );
                        })
                .subscribe();
    }

    public void seatStart(Transfer trans) {

    }

    public void seatEnd(String openUserId, String catchUserId) {

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
                                redisTemplate.opsForHash().put("train:" + (String) cg, "villain", Integer.valueOf((String) num)-1))
                        .subscribe();

                tcgRepo.getTrainChannelGroupMap().get(cg).writeAndFlush(trans);
            });
    }
}
