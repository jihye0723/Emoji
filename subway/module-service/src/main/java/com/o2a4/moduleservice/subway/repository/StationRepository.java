package com.o2a4.moduleservice.subway.repository;

import com.o2a4.moduleservice.subway.document.Station;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StationRepository extends MongoRepository<Station, String> {

    boolean existsByStationCode(String s);
}
