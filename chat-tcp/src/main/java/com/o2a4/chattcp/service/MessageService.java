package com.o2a4.chattcp.service;

import com.o2a4.chattcp.proto.TransferOuterClass.Transfer;
import com.o2a4.chattcp.repository.ChannelIdChannelRepository;
import com.o2a4.chattcp.repository.TrainChannelGroupRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageService {
    private final TrainChannelGroupRepository tcgRepo;
    private final ChannelIdChannelRepository cidcRepo;

    public String receiveMessage(Transfer trans) {
        // TODO 필터링
        String msg = "";
        return msg;
    }

    public void sendMessage(Transfer trans, String msg) {
        // TODO 메세지 보내기
    }

}
