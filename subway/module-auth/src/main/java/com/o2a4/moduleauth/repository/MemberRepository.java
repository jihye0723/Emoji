package com.o2a4.moduleauth.repository;

import com.o2a4.moduleauth.document.Member;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MemberRepository extends MongoRepository<Member, String> {
    boolean existsByKakaoId(String s);
    Member findByKakaoId(String s);
    Optional<Member>  findByEmail(String s);

}
