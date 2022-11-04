package com.o2a4.moduleservice.seat.controller;


import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

@RestController
@RequestMapping("/seat")
@AllArgsConstructor
@Slf4j
public class SeatController {

   private final ReactiveRedisTemplate<String, String> reactiveRedisTemplate;


    // 채팅서버로부터 양도자 id 받아서, redis 생성 > 5초 후 1명 뽑아서 양도자id + 당첨자id 보내주기
    // WebClient 로 통신하면 될듯 ?
    @GetMapping("/{userid}")
    public void seatCompeteOpen(@PathVariable String userid){
        log.info(userid);
        // userid : 자리 양도한 사람 아이디
        String key = "seat:"+userid; // ex) key = seat:ssafy
        Timer t= new Timer();

        //redis 에서 한명 뽑기
        Winning wt = new Winning(key);
        //5초가 지난후에, 해당 작업 실행
        t.schedule(wt, 5000);


    }


    // 자리양도 주최한 사람 + 자리양도 신청한 신청자
    // 신청자 id redis 에 넣기
    @PostMapping
    public void seatAttend(@RequestBody Map<String, String> seatMap){
        // 참가신청한 사용자 아이디
        String attend_id = seatMap.get("attend_id");
        // 자리양도 시작한 사용자 아이디
        String start_id = seatMap.get("start_id");

        System.out.println("참가자 : " + attend_id + " , 양도자 : "+ start_id);
        // userid : 자리 양도한 사람 아이디
        String key = "seat:"+start_id; // ex) key = seat:ssafy
        log.debug("redis key : "+  key);
        reactiveRedisTemplate.opsForValue().set(key, attend_id);





    }
    class Winning extends TimerTask{
        private String key;

        public Winning(String key){
            this.key=key;
        }
        @Override
        public void run() {
            // redis 에서 한명뽑기
        }
    }
}
