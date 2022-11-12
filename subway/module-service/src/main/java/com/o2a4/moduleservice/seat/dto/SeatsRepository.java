package com.o2a4.moduleservice.seat.dto;


import org.springframework.stereotype.Component;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class SeatsRepository {
    private final Set<String> seatUser = ConcurrentHashMap.newKeySet();

    public Set<String> getSeatUser() {
        return seatUser;
    }

}
