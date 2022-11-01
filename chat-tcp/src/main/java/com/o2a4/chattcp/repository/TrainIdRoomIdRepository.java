package com.o2a4.chattcp.repository;

import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class TrainIdRoomIdRepository {

    private final Map<String, String> trainIdRoomIdMap = new ConcurrentHashMap<>();

    public Map<String, String> getTrainIdRoomIdMap() {
        return trainIdRoomIdMap;
    }
}
