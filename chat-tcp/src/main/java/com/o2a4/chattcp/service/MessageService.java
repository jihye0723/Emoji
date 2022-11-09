package com.o2a4.chattcp.service;

import com.o2a4.chattcp.proto.TransferOuterClass.Transfer;
import com.o2a4.chattcp.repository.ChannelIdChannelRepository;
import com.o2a4.chattcp.repository.TrainChannelGroupRepository;
import com.o2a4.chattcp.util.AhoCorasick;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.List;
import java.util.TreeMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class MessageService {
    private final TrainChannelGroupRepository tcgRepo;
    private final ChannelIdChannelRepository cidcRepo;

    public String receiveMessage(Transfer trans) {
        // TODO 필터링

        // Collect test data set
        AhoCorasick ac = new AhoCorasick();
        String[] keyArray = new String[]
                {
                        "hers",
                        "his",
                        "she",
                        "he"
                };
        for (String key : keyArray)
        {
            ac.addKeyword(key);
        }

        Collection<AhoCorasick.Emit> emits = ac.parseText("asdfonvhwe asdfckf eidh her s asdlhsidhis hers!!!!");

        for (AhoCorasick.Emit emit : emits) {
            System.out.println(emit.getStart() + " " + emit.getEnd() + "\t" + emit.getKeyword());
        }

        String msg = "";
        return msg;
    }

    public void sendMessage(Transfer trans, String msg) {
        // TODO 메세지 보내기
    }

}
