package com.o2a4.moduleservice.seat.dto;


import lombok.Data;

@Data
public class Seats {
    //양도자 id
    private String userId;
    //당첨자 id
    private String winnerId;
    //자리 정보
    private String content;
}
