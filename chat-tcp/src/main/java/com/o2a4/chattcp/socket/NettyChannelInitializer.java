package com.o2a4.chattcp.socket;

import com.o2a4.chattcp.config.NettyConfiguration;
import com.o2a4.chattcp.handler.ChatHandler;
import com.o2a4.chattcp.proto.TransferOuterClass;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.handler.codec.protobuf.ProtobufDecoder;
import io.netty.handler.codec.protobuf.ProtobufEncoder;
import io.netty.handler.codec.protobuf.ProtobufVarint32FrameDecoder;
import io.netty.handler.codec.protobuf.ProtobufVarint32LengthFieldPrepender;
import io.netty.handler.logging.LogLevel;
import io.netty.handler.logging.LoggingHandler;
import io.netty.util.concurrent.DefaultEventExecutorGroup;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class NettyChannelInitializer extends ChannelInitializer<SocketChannel> {

    private final ChatHandler chatHandler;

    @Value("${server.netty.logLevel}")
    private String logLevel;

    // 클라이언트 소켓 채널이 생성될 때 호출
    @Override
    protected void initChannel(SocketChannel ch) {
        ChannelPipeline pipeline = ch.pipeline();
        // 뒤이어 처리할 디코더, 로거 및 핸들러 추가
        pipeline
                //ProtoBuf Decoder
                .addLast(new ProtobufVarint32FrameDecoder())
                .addLast(new ProtobufDecoder(TransferOuterClass.Transfer.getDefaultInstance()))
                //Logger, Event Handler
                .addLast(new LoggingHandler(LogLevel.valueOf(logLevel)))
//                .addLast(workerGroup, chatHandler)
                .addLast(chatHandler)
                //ProtoBuf Encoder
                .addLast(new ProtobufVarint32LengthFieldPrepender())
                .addLast(new ProtobufEncoder());
    }
}