package com.o2a4.chattcp.repository;

import io.netty.channel.ChannelId;
import org.springframework.stereotype.Component;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ChannelIdUserIdRepository {
    private final Map<ChannelId, String> channelIdUserIdMap = new ConcurrentHashMap<>();

    public Map<ChannelId, String> getChannelIdUserIdMap() {
        return channelIdUserIdMap;
    }
}
