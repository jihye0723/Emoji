package com.o2a4.moduleauth.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.o2a4.moduleauth.dto.TokenInfo;
import com.o2a4.moduleauth.service.LoginService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/oauth")
@AllArgsConstructor
public class LoginController {

    private final LoginService loginService;

    @PostMapping(value = "/kakao-login")
    public ResponseEntity<TokenInfo> Login(@RequestParam("access-token") String accessToken) throws JsonProcessingException {
        log.info("/login");
        return ResponseEntity.ok(loginService.kakaoLogin(accessToken));
    }

    @GetMapping(value = "/test")
    public ResponseEntity<String> Test()  {

        return ResponseEntity.ok("Success");
    }

    @GetMapping(value = "/testt")
    public ResponseEntity<String> Test2()  {

        return ResponseEntity.ok("testt");
    }
}
