package com.o2a4.moduleservice.seat.controller;


import com.o2a4.moduleservice.seat.dto.Seats;
import com.o2a4.moduleservice.seat.dto.SeatsRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import javax.xml.ws.Response;
import java.util.*;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/seat")
@AllArgsConstructor
@Slf4j
public class SeatController {

    private final SeatsRepository seatsRepository;

    private final RedisTemplate<String, String> redisTemplate;


    /*자리 양도 시작*/
    @GetMapping("/{userId}")
    public String startSeat(@PathVariable String userId) {
        seatsRepository.getSeatUser().add(userId);
        log.info("자리 양도 시작 [주최자]  :" + userId);

        String key = "seat:"+userId; // ex)seat:ssafy
        redisTemplate.opsForList().rightPush(key, "start");
        return "success";
    }

/*-------------------이거 왜 오래걸림 ?-------------------------*/
    /*자리 양도 신청*/
    /*{ "userId" : 양도자 id,  "attend_id" : 참가자 id } */
    @PostMapping("/attend")
    public ResponseEntity<?> attendSeat(@RequestBody Map<String, String> seatMap){
       String attend_id= seatMap.get("attend_id");
       String userId = seatMap.get("userId");

        log.info("[자리 양도 참가]");
        log.info("attend_id : " + attend_id );
        log.info("userId : " + userId );
       //start_id가 현재 활성화 된 아이디 인지 확인
        boolean HasUser = seatsRepository.getSeatUser().contains(userId);
        if(!HasUser){
            // 자리 양도 안한 것
            return new ResponseEntity<String>("fail", HttpStatus.OK);
        }
       String key = "seat:"+userId; // ex)seat:ssafy

        redisTemplate.opsForList().rightPush(key, attend_id);

        return new ResponseEntity<String>("success", HttpStatus.OK);
    }


    /*자리 양도 종료*/
    /*{ "userId" : 양도자 id , "content" : 자리 정보 } */
    @PostMapping("/finish")
    public ResponseEntity<?> finishSeat(@RequestBody Map<String, String> finishInfo){
        String userId = finishInfo.get("userId");
        String content = finishInfo.get("content");

        log.info("[자리 양도 종료]");
        log.info("userId : " + userId );
        log.info("content : " + content );
        Seats seatsInfo = new Seats();
        seatsInfo.setUserId(userId);
        seatsInfo.setContent(content);

        //redis에서 key 값으로 참가리스트 가지고 오기
        String key = "seat:"+userId; // ex)seat:ssafy
//        boolean isKeyEmpty = redisTemplate.keys(key).isEmpty();
        Long size=  redisTemplate.opsForList().size(key);
        /*참가자가 없음*/
        if(size == 1){
            //당첨자 NULL
            seatsInfo.setWinnerId(null);
        }
        /*참가자가 있음*/
        else{

            List<String> attendList=  redisTemplate.opsForList().range(key, 1, size-1);

            Random random = new Random();
            int randomIndex = random.nextInt(attendList.size());
            String winnerId = attendList.get(randomIndex);

            seatsInfo.setWinnerId(winnerId);
        }
        String portkey ="user:"+userId;
        String port = (String) redisTemplate.opsForHash().get(portkey, "server");
        
        // seatsInfo : 양도자/당첨자/자리정보 담겨있는 객체
        RestTemplate restTemplate = new RestTemplate();
        String path ="http://k7a6021.p.ssafy.io:"+port+"/seat/finish";
        log.info("path : " + path );
        restTemplate.postForObject(path, seatsInfo, String.class );

        // redis에서 해당 키 삭제
        redisTemplate.expire(key, 3, TimeUnit.SECONDS);
        // 자리양도 주최자 mem 에서 삭제
        seatsRepository.getSeatUser().remove(userId);

        return new ResponseEntity<String>("success", HttpStatus.OK);
    }

}
