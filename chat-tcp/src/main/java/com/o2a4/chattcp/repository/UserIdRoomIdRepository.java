package com.o2a4.chattcp.repository;

import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class UserIdRoomIdRepository {

    private final Map<String, String> userIdRoomIdMap = new ConcurrentHashMap<>();

    public Map<String, String> getUserIdRoomIdMap() {
        return userIdRoomIdMap;
    }
}
