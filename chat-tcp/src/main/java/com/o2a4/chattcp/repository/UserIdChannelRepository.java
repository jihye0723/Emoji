package com.o2a4.chattcp.repository;

import io.netty.channel.Channel;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class UserIdChannelRepository {

//    @Autowired
//    private LoginService loginService;
    private final Map<String, Channel> userIdChannelMap = new ConcurrentHashMap<>();

    public Map<String, Channel> getUserIdChannelMap() {
        return userIdChannelMap;
    }

    /*
    public void writeAndFlush(String returnMessage) throws Exception {

        userIdChannelMap.values().parallelStream().forEach(channel -> {

            if (!channel.isActive()) {

                loginService.removeUser(channel);
                channel.close();
                return;

            }

            channel.writeAndFlush(returnMessage + System.lineSeparator());

        });

    }
    */

}
