package com.o2a4.chattcp.repository;

import com.o2a4.chattcp.util.AhoCorasickDoubleArrayTrie;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class FilterRepository {
    private final AhoCorasickDoubleArrayTrie filterTrie = new AhoCorasickDoubleArrayTrie();

    public AhoCorasickDoubleArrayTrie getFilterTrie() {
        return filterTrie;
    }
}
