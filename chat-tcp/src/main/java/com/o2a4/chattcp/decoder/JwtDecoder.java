package com.o2a4.chattcp.decoder;

import org.springframework.stereotype.Component;

@Component
public class JwtDecoder {
    public static String decode(String token) {
        return "ssafy";
    }
}
