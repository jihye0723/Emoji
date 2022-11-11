package com.o2a4.chattcp.repository;

import com.o2a4.chattcp.util.filter.AhoCorasickDoubleArrayTrie;
import org.springframework.stereotype.Component;

@Component
public class FilterRepository {
    private final AhoCorasickDoubleArrayTrie filterTrie = new AhoCorasickDoubleArrayTrie();

    public AhoCorasickDoubleArrayTrie getFilterTrie() {
        return filterTrie;
    }
}
