package com.o2a4.moduleservice.subway.controller;

import lombok.AllArgsConstructor;
import com.o2a4.moduleservice.subway.document.Station;
import com.o2a4.moduleservice.subway.service.SubwayService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/subway")
@AllArgsConstructor
public class SubwayController {

    private final SubwayService subwayService;

//    @PathVariable("id")
    @GetMapping(value = "/station")
    public ResponseEntity<User>  home(@RequestParam("latitude") String latitude, @RequestParam("longtitude") String longtitude){

        return ResponseEntity.ok(subwayService.findStation(user));
    }


    @GetMapping("/board")
    public List<Station> findAll() { // 리턴을 JavaObject로 하면 스프링 내부적으로 JSON으로 자동 변환 해준다.
        return stationRepository.findAll();
    }
}
