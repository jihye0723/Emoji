package com.o2a4.chattcp.service;

import com.o2a4.chattcp.proto.TransferOuterClass.Transfer;
import com.o2a4.chattcp.repository.ChannelIdChannelRepository;
import com.o2a4.chattcp.repository.FilterRepository;
import com.o2a4.chattcp.repository.TrainChannelGroupRepository;
import com.o2a4.chattcp.util.AhoCorasickDoubleArrayTrie;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.LinkedList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageService {
    private final ReactiveRedisTemplate<String, String> redisTemplate;
    private final TrainChannelGroupRepository tcgRepo;
    private final ChannelIdChannelRepository cidcRepo;
    private final FilterRepository filterRepo;

    public String receiveMessage(Transfer trans) {
        // FIXME 공백이랑 숫자 처리 어케하지,,

        StringBuilder sb = new StringBuilder();
//        String test = "ㅆ ㅂ"
        String test = "이ㅆㅂ ㅆ12ㅂ ㄱㅅㄲㅆㅂ ㄱㅆㅂㅅㄲ";
        LinkedList<Integer[]> output = new LinkedList<>();

//        List<AhoCorasickDoubleArrayTrie.Hit<?>> res = filterRepo.getFilterTrie().customParseText(test);
        List<AhoCorasickDoubleArrayTrie.Hit<?>> res = filterRepo.getFilterTrie().parseText(test);


        // 비속어가 있다면
        if (res != null) {
            // 구간들을 병합해서 하나의 리스트로 변환
            for (AhoCorasickDoubleArrayTrie.Hit interval : res) {
                if (output.isEmpty() || output.getLast()[1] < interval.begin) {
                    output.add(new Integer[]{interval.begin, interval.end});
                } else {
                    output.getLast()[1] = Math.max(output.getLast()[1], interval.end);
                }
            }

            // 마스킹처리
            int ptr = 0;
            for (Integer[] interval : output) {
                int start = interval[0];
                int end = interval[1];

                // 비속어 시작 전까지 그대로 붙이고 비속어 파트는 *로 대체
                sb.append(test, ptr, start).append("*");
                // 비속어 끝(exclusive)을 다음 시작점으로 지정
                ptr = end;
            }
        }

        return sb.toString();
    }

    public void sendMessage(Transfer trans, String msg) {
        String userId = trans.getUserId();

        Transfer send = Transfer.newBuilder(trans).setContent(msg).build();

        redisTemplate.opsForHash().get("user:" + userId, "channelGroup")
                .subscribe(cg -> {
                    log.info("SEND MESSAGE TO ROOM");
                    // 열차 채팅방에 채널 추가
                    tcgRepo.getTrainChannelGroupMap().get(cg).writeAndFlush(send);
                });
    }

    public void sendMessageToOneByServer(String ChannelGroupId, String ChannelId, Object data) {
//    public void sendMessageToOneByServer(ChannelGroup channelGroup, Channel channel, Object data) {
        // TODO 서버가 원할 때 메세지를 한 명에게 보낼 수 있도록 하는 기능
    }

    public void sendMessageToRoomByServer(String ChannelGroupId, Object data) {
//    public void sendMessageToRoomByServer(ChannelGroup ChannelGroup, Object data) {
        // TODO 서버가 원할 때 채팅방에 메세지를 뿌릴 수 있도록 하는 기능
    }
}
