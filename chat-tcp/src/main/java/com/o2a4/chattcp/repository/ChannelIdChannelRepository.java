package com.o2a4.chattcp.repository;

import io.netty.channel.Channel;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ChannelIdChannelRepository {
    private final Map<String, Channel> channelIdChannelMap = new ConcurrentHashMap<>();

    public Map<String, Channel> getChannelIdChannelMap() {
        return channelIdChannelMap;
    }
}
