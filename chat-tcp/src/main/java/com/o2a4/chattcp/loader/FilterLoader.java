package com.o2a4.chattcp.loader;

import com.o2a4.chattcp.repository.FilterRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class FilterLoader {

    private final FilterRepository filterRepository;

    @PostConstruct
    public void loadFilter() {
        // TODO 비속어 데이터 로드
        Map<String, String> map = new HashMap<>();

        // 여기 수정
       map.put("","");

        filterRepository.getFilterTrie().build(map);
    }
}
