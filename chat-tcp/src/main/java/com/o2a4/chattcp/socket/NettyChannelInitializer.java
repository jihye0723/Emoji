package com.o2a4.chattcp.socket;

import com.o2a4.chattcp.config.NettyConfiguration;
import com.o2a4.chattcp.decoder.TestDecoder;
import com.o2a4.chattcp.handler.TestHandler;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.socket.SocketChannel;
import io.netty.handler.logging.LogLevel;
import io.netty.handler.logging.LoggingHandler;
import io.netty.util.concurrent.DefaultEventExecutorGroup;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class NettyChannelInitializer extends ChannelInitializer<SocketChannel> {
    private final TestHandler testHandler;

    private final DefaultEventExecutorGroup workerGroup = NettyConfiguration.workerGroup();

    @Value("${server.netty.logLevel}")
    private String logLevel;

    // 클라이언트 소켓 채널이 생성될 때 호출
    @Override
    protected void initChannel(SocketChannel ch) {
        ChannelPipeline pipeline = ch.pipeline();
        // 원래 프레임워크에서 지원하는 디코더는 @Sharable인데..? => final로 한번에 가져다 쓰는게
        TestDecoder testDecoder = new TestDecoder();

        // 뒤이어 처리할 디코더, 로거 및 핸들러 추가
        pipeline.addLast(testDecoder)
                .addLast(new LoggingHandler(LogLevel.valueOf(logLevel)))
                .addLast(workerGroup, testHandler);
    }
}