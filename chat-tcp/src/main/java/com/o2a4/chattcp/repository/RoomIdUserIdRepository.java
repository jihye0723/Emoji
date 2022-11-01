package com.o2a4.chattcp.repository;

import org.springframework.stereotype.Component;

import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class RoomIdUserIdRepository {
    private final ConcurrentHashMap<String, List<String>> roomIdUserIdMap = new ConcurrentHashMap<>();

    public ConcurrentHashMap<String, List<String>> getRoomIdUserIdMap() {
        return roomIdUserIdMap;
    }
}
