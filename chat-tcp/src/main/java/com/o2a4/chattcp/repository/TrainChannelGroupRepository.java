package com.o2a4.chattcp.repository;

import io.netty.channel.group.ChannelGroup;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class TrainChannelGroupRepository {
    private final Map<String, ChannelGroup> trainChannelGroupMap = new ConcurrentHashMap<>();

    public Map<String, ChannelGroup> getTrainChannelGroupMap() {
        return trainChannelGroupMap;
    }
}
