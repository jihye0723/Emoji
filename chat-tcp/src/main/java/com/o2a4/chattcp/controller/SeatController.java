package com.o2a4.chattcp.controller;


import com.o2a4.chattcp.model.Seats;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/* 자리양도 완료 되었을 때, 당첨자 받는 컨트롤러 */
@RestController
@RequestMapping("/seat")
@Slf4j
public class SeatController {

    @PostMapping("/finish")
    public String getSeatInfo(@RequestBody Seats seatsInfo){
        log.info("양도자 : {}, 당첨자 : {}, 자리 정보 : {}", seatsInfo.getUserId(), seatsInfo.getWinnerId(),
                seatsInfo.getContent());
        return "ok";
    }

}
