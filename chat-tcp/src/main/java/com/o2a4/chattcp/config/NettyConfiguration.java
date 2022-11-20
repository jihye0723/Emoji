package com.o2a4.chattcp.config;

import com.o2a4.chattcp.socket.NettyChannelInitializer;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.ChannelOption;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.logging.LogLevel;
import io.netty.handler.logging.LoggingHandler;
import io.netty.util.internal.SystemPropertyUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.net.InetSocketAddress;
import java.net.UnknownHostException;

@Configuration
@RequiredArgsConstructor
public class NettyConfiguration {

//    private final DefaultEventExecutorGroup workerGroup = this.workerGroup();

    @Value("${server.netty.transfer.port}")
    private int transferPort;
    @Value("${server.netty.bossCount}")
    private int bossCount;
    //    @Value("${server.netty.ioCount}")
//    private int ioCount;
    @Value("${server.netty.workerCount}")
    private int workerCount;
    @Value("${server.netty.keepAlive}")
    private boolean keepAlive;
    @Value("${server.netty.backlog}")
    private int backlog;
    @Value("${server.netty.logLevel}")
    private String logLevel;

    @Bean
    public ServerBootstrap serverBootstrap(NettyChannelInitializer nettyChannelInitializer) {
        // ServerBootstrap: 서버 설정을 도와주는 class
        ServerBootstrap serverBootstrap = new ServerBootstrap();
//        serverBootstrap.group(bossGroup(), ioGroup())
        serverBootstrap.group(bossGroup(), workerGroup())
                // NioServerSocketChannel: incoming connections를 수락하기 위해 새로운 Channel을 객체화할 때 사용
                .channel(NioServerSocketChannel.class)
                .handler(new LoggingHandler(LogLevel.valueOf(logLevel)))
//                이거 적용시키면 수신 없으면 종료, 송신 없으면 컨택, 둘다 세팅 이렇게 가능한데,,
//                .childHandler(new IdleStateHandler(1,2,0))
                // ChannelInitializer: 새로운 Channel을 구성할 때 사용되는 특별한 handler. 주로 ChannelPipeline으로 구성
                .childHandler(nettyChannelInitializer);

        // ServerBootstrap에 다양한 Option 추가 가능

        // 이 외에도 SO_KEEPALIVE, TCP_NODELAY 등 옵션 제공
        serverBootstrap.option(ChannelOption.SO_BACKLOG, backlog);  // SO_BACKLOG: 동시에 수용 가능한 최대 incoming connections 개수
        serverBootstrap.childOption(ChannelOption.TCP_NODELAY, true);   // nagle알고리즘 비활성화로 반응속도 향상
        serverBootstrap.childOption(ChannelOption.SO_REUSEADDR, true);  // TIME_WAIT 소켓을 재활용
//        serverBootstrap.childOption(ChannelOption.SO_LINGER, 0);    // TIME_WAIT을 남기지 않고 빠르게 강제종료 할 수 있게 하지만 특수한 경우가 아니라면 사용 X
        serverBootstrap.childOption(ChannelOption.SO_KEEPALIVE, true); //OS에 따라 옵션이 다르다

        return serverBootstrap;
    }

    // boss: incoming connection을 수락하고, 수락한 connection을 worker에게 등록(register)
    @Bean(destroyMethod = "shutdownGracefully")
    public NioEventLoopGroup bossGroup() {
        return new NioEventLoopGroup(bossCount);
    }

    // io: worker에서 I/O만 분리하여 처리
//    @Bean(destroyMethod = "shutdownGracefully")
//    public NioEventLoopGroup ioGroup() {
//        return new NioEventLoopGroup(ioCount);
//    }

    // worker: boss가 수락한 연결 핸들링
    @Bean(destroyMethod = "shutdownGracefully")
    public NioEventLoopGroup workerGroup() {
//        application.properties 로 정의한 내용을 쓸 때는 workerCount 로!
        int DEFAULT_WORKERGROUP_THREADS = Math.max(1, SystemPropertyUtil.getInt("io.netty.eventLoopThreads", Runtime.getRuntime().availableProcessors() * 2));

        return new NioEventLoopGroup(DEFAULT_WORKERGROUP_THREADS);
//        return new NioEventLoopGroup(DEFAULT_WORKERGROUP_THREADS);        기본 NioEventLoopGroup
    }

    /*@Bean(destroyMethod = "shutdownGracefully")
    public DefaultEventExecutorGroup workerGroup() {
//        application.properties 로 정의한 내용을 쓸 때는 workerCount 로!
        int DEFAULT_WORKERGROUP_THREADS = Math.max(1, SystemPropertyUtil.getInt("io.netty.eventLoopThreads", Runtime.getRuntime().availableProcessors() * 2));

//        io와 작업핸들러를 분리
        return new DefaultEventExecutorGroup(DEFAULT_WORKERGROUP_THREADS);
//        return new NioEventLoopGroup(DEFAULT_WORKERGROUP_THREADS);        기본 NioEventLoopGroup
    }*/

    // IP 소켓 주소(IP 주소, Port 번호)를 구현
    // 도메인 이름으로 객체 생성 가능
    @Bean
    public InetSocketAddress inetSocketAddress() throws UnknownHostException {

//        System.out.println("주소 찍기" + " " + InetAddress.getLocalHost().getHostAddress());
//        return new InetSocketAddress(InetAddress.getLocalHost(), port);

        return new InetSocketAddress(transferPort);
    }
}