package com.o2a4.chattcp.repository;

import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class TrainChannelGroupRepository {
    private final Map<Integer, String> trainChannelGroupMap = new ConcurrentHashMap<>();

    public Map<Integer, String> getTrainChannelGroupMap() {
        return trainChannelGroupMap;
    }
}
