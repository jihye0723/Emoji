package com.o2a4.chattcp.loader;

import com.o2a4.chattcp.repository.FilterRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

@Component
@RequiredArgsConstructor
public class FilterLoader {

    private final FilterRepository filterRepository;

    @PostConstruct
    public void loadFilter() {
        ClassPathResource resource = new ClassPathResource("data/FwordList.txt");
        Map<String, String> map = new TreeMap<>();

        BufferedReader br = null;

        try {
            br = new BufferedReader(new InputStreamReader(resource.getInputStream()));
            System.out.println("READ");

            String str = br.readLine();
            while (str != null) {
                map.put(str, str);
                str = br.readLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (br != null) {
                    br.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        // 비속어 필터링용 맵 세팅
        filterRepository.getFilterTrie().build(map);
        System.out.println("FILTER LOAD TRIE SIZE : " + filterRepository.getFilterTrie().size());
    }
}
