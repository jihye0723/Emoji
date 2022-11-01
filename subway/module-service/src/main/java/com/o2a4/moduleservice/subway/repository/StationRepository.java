package com.o2a4.moduleservice.subway.repository;

import com.o2a4.moduleservice.subway.document.Station;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface StationRepository extends MongoRepository<Station, String> {
    void findByLatitudeAndLongtitudeNe
}
