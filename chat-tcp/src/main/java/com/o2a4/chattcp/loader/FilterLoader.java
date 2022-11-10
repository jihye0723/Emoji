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

        map.put("ㅆㅂ", "ㅆㅂ");
        map.put("ㄱㅅㄲ", "ㄱㅅㄲ");
        map.put("ㄱㅆㅂ", "ㄱㅆㅂ");
        map.put("ㄱㅆㅂㅅㄲ", "ㄱㅆㅂㅅㄲ");
        map.put("ㅆㅂㅅㄲ", "ㅆㅂㅅㄲ");

        // 비속어 필터링용 맵 세팅
        filterRepository.getFilterTrie().build(map);
    }
}
