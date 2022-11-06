package com.o2a4.moduleservice.seat.controller;


import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.bind.annotation.*;

import javax.xml.ws.Response;
import java.util.*;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/seat")
@AllArgsConstructor
@Slf4j
public class SeatController {

    private final RedisTemplate<String, String> redisTemplate;

    // 채팅서버로부터 양도자 id 받아서, redis 생성 > 5초 후 1명 뽑아서 양도자id + 당첨자id 보내주기
    // WebClient 로 통신하면 될듯 ?
    @GetMapping("/{userid}")
    public Map<String,String> seatCompeteOpen(@PathVariable String userid) throws InterruptedException {
        log.info(userid);
        // userid : 자리 양도한 사람 아이디
        String key = "seat:"+userid; // ex) key = seat:ssafy
        // redis 생성
        redisTemplate.opsForList().rightPush(key, "start");
        redisTemplate.expire(key, 180, TimeUnit.SECONDS); // 3분동안 redis 에 저장
//        /*Timer 사용했을 떄 */
//        Timer t= new Timer();
//        //redis 에서 한명 뽑기
//        Winning wt = new Winning(key);
//        //5(+1)초가 지난후에, 해당 작업 실행
//        t.schedule(wt, 6000);

        /*Thread.sleep 사용했을 때 */
        try{
            Thread.sleep(6000);
        }catch(InterruptedException e){
            e.printStackTrace();
        }
        Long size= redisTemplate.opsForList().size(key);
        // 참가자 목록 얻어오기 : list
        List<String> list= redisTemplate.opsForList().range(key, 1, size-1);

        Random random = new Random();
        int randomIndex = random.nextInt(list.size());
        String win_id = list.get(randomIndex);

        Map<String, String> map = new HashMap<>();
        map.put("UserId", userid);
        map.put("WinnerId", win_id);
        log.info("당첨자 id : " + win_id +", 양도자 id : "+ userid);

        return map;
    }

    // 자리양도 주최한 사람 + 자리양도 신청한 신청자
    // 신청자 id redis 에 넣기
    @PostMapping
    public void seatAttend(@RequestBody Map<String, String> seatMap){
        // 참가신청한 사용자 아이디
        String attend_id = seatMap.get("attend_id");
        // 자리양도 시작한 사용자 아이디
        String start_id = seatMap.get("start_id");
        //log.info("참가자 : " + attend_id + " , 양도자 : "+ start_id);

        // userid : 자리 양도한 사람 아이디
        String key = "seat:"+start_id; // ex) key = seat:ssafy

        redisTemplate.opsForList().rightPush(key, attend_id);
    }
//    class Winning extends TimerTask{
//        private String key;
//
//        public Winning(String key){
//            this.key=key;
//        }
//        @Override
//        public void run() {
//            // redis 에서 한명뽑기 ( 1부터 뽑아야함 )
//            // size
//            Long size= redisTemplate.opsForList().size(key);
//            // 참가자 목록 얻어오기 : list
//            List<String> list= redisTemplate.opsForList().range(key, 1, size-1);
//
//            Random random = new Random();
//            int randomIndex = random.nextInt(list.size());
//            String win_id = list.get(randomIndex);
//            log.info("당점자 : " +win_id);
//        }
//    } // winning class

}
