package com.o2a4.chattcp.handler;

import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelHandler;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.web.ServerProperties;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@ChannelHandler.Sharable
@RequiredArgsConstructor
public class ChatHandler extends ChannelInboundHandlerAdapter {
    // 핸들러가 생성될 때 호출되는 메소드
    @Override
    public void handlerAdded(ChannelHandlerContext ctx) {
    }

    // 핸들러가 제거될 때 호출되는 메소드
    @Override
    public void handlerRemoved(ChannelHandlerContext ctx) {
    }

    // 클라이언트와 연결되어 트래픽을 생성할 준비가 되었을 때 호출되는 메소드
    @Override
    public void channelActive(ChannelHandlerContext ctx) {
        String remoteAddress = ctx.channel().remoteAddress().toString();
        log.info("Remote Address: " + remoteAddress);

        // TODO 입장 처리 - Map에 채널ID, 채널 저장 & Redis에 유저-채널-채널id 저장
    }


    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg){
//        ByteBuf mBuf = (ByteBuf) msg;
//        buff.writeBytes(mBuf);  // 클라이언트에서 보내는 데이터가 축적됨
//        mBuf.release();

        System.out.println("MESSAGE\n" + msg);

        final ChannelFuture f = ctx.writeAndFlush(msg);
//        f.addListener(ChannelFutureListener.CLOSE);
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
        // Close the connection when an exception is raised.
        ctx.close();
        cause.printStackTrace();
    }

}