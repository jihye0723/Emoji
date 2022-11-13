package com.o2a4.chattcp.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
public class Seats {
    // 당첨자
    String winnerId;
    // 양도자
    String userId;
    // 자리 정보
    String content;
}
