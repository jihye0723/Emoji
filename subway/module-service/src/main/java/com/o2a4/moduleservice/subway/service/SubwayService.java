package com.o2a4.moduleservice.subway.service;

import com.o2a4.moduleservice.subway.repository.StationRepository;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@AllArgsConstructor
public class SubwayService {
    private final StationRepository stationRepository;

}
