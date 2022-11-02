package com.o2a4.chattcp.repository;

import io.netty.channel.ChannelId;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class TrainChannelGroupRepository {

    private final Map<Integer, String> trainChannelGroupMap = new ConcurrentHashMap<>();

    public Map<Integer, String> getTrainChannelGroupMap() {
        return trainChannelGroupMap;
    }
}
