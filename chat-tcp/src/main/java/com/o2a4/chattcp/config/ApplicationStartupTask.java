package com.o2a4.chattcp.config;
import com.o2a4.chattcp.socket.NettyServerSocket;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

import java.net.InetSocketAddress;

@Component
@RequiredArgsConstructor
public class ApplicationStartupTask implements ApplicationListener<ApplicationReadyEvent> {

    private final NettyServerSocket nettyServerSocket;

    @Override
    public void onApplicationEvent(ApplicationReadyEvent event) {
        try {
            nettyServerSocket.start();
        }
        finally {
            nettyServerSocket.stop();
        }
    }

}
