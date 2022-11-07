package com.o2a4.moduleauth.controller;

import com.o2a4.moduleauth.service.LoginService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/oauth")
@AllArgsConstructor
public class LoginController {

    private final LoginService loginService;

    //    @PathVariable("id")
    @PostMapping(value = "/kakao-login")
    public ResponseEntity<String> findStationByGps(@RequestParam("access-token") String accessToken)  {

        return ResponseEntity.ok(loginService.kakaoLogin(accessToken));
    }
}
