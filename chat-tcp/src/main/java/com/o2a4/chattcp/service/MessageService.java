package com.o2a4.chattcp.service;

import com.o2a4.chattcp.proto.TransferOuterClass;
import com.o2a4.chattcp.proto.TransferOuterClass.Transfer;
import com.o2a4.chattcp.repository.ChannelIdChannelRepository;
import com.o2a4.chattcp.repository.FilterRepository;
import com.o2a4.chattcp.repository.TrainChannelGroupRepository;
import com.o2a4.chattcp.util.filter.AhoCorasickDoubleArrayTrie;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
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
        // FIXME 공백이랑 숫자 처리 -> 배열을 같은 크기로 만들어서 문자열 위치를 매핑하고, 필요없는 부분 정규표현식으로 다 삭제하고 필터링?

        StringBuilder sb = new StringBuilder();
//        String test = "ㅆ ㅂ"
        String test = "이ㅆㅂ ㅆ12ㅂ ㄱㅅㄲㅆㅂ ㄱㅆㅂㅅㄲ";   // 이* ㅆ12ㅂ * *
        LinkedList<Integer[]> output = new LinkedList<>();

//        List<AhoCorasickDoubleArrayTrie.Hit<?>> res = filterRepo.getFilterTrie().customParseText(test);
        List<AhoCorasickDoubleArrayTrie.Hit<?>> res = filterRepo.getFilterTrie().parseText(test);

        // 비속어가 있다면
        if (res != null) {
            // 구간들을 정렬
            res.sort((o1, o2) -> o1.begin - o2.begin);

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

            if (ptr < test.length()) {
                sb.append(test, ptr, test.length());
            }
        }

        return sb.toString();
    }

    public void sendMessage(Transfer trans, String msg) {
        String userId = trans.getUserId();

        Transfer send = Transfer.newBuilder(trans).setContent(msg).build();

        redisTemplate.opsForHash().get("user:" + userId, "channelGroup")
                .subscribe(cg -> {
                    // 열차 채팅방에 사용자의 메세지 전달
                    log.info("SEND MESSAGE TO ROOM");
                    tcgRepo.getTrainChannelGroupMap().get(cg).writeAndFlush(send);
                });
    }

    public void sendMessageToOneByServer(Transfer trans, String type, String content) {
        String userId = trans.getUserId();

        // 전달할 메세지 생성
        Transfer.Builder builder = serverTrans(type, content);

        redisTemplate.opsForHash().get("user:" + userId, "channel")
                .subscribe(c -> {
                    // 유저 한 명에게 메시지 전송
                    log.info("SEND MESSAGE TO USER");
                    cidcRepo.getChannelIdChannelMap().get(c).writeAndFlush(builder);
                });
    }

    public void sendMessageToRoomByServer(String channelGroupId, String type, String content) {
        // 전달할 메세지 생성
        Transfer.Builder builder = serverTrans(type, content);

        // 채팅방에 메시지 전송
        log.info("SEND MESSAGE TO USER");
        tcgRepo.getTrainChannelGroupMap().get(channelGroupId).writeAndFlush(builder);
    }

    private static Transfer.Builder serverTrans(String type, String content) {
        Transfer.Builder builder = Transfer.newBuilder();

        builder.setType(type);
        builder.setContent(content);

        // 서버로 고정
        builder.setUserId("SERVER");
        builder.setNickName("SERVER");
        builder.setSendAt(LocalDateTime.now().toString());

        builder.build();

        return builder;
    }
}
