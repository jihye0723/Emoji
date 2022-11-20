package com.o2a4.moduleservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
//@ComponentScan(basePackages = "com.o2a4.moduleservice")
@EnableMongoRepositories(basePackages = "com.o2a4.moduleservice")//(basePackageClasses = com.o2a4.moduleservice.subway.repository.StationRepository.class)
//@EnableAutoConfiguration
public class ModuleServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(ModuleServiceApplication.class, args);
    }

}
