package com.o2a4.chattcp.handler;

import com.o2a4.chattcp.proto.TransferOuterClass;
import com.o2a4.chattcp.service.MessageService;
import com.o2a4.chattcp.service.RoomService;
import io.netty.channel.ChannelHandler;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@ChannelHandler.Sharable
@RequiredArgsConstructor
public class ChatHandler extends ChannelInboundHandlerAdapter {
    private final RoomService roomService;
    private final MessageService messageService;

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
        log.info("[OPEN] Remote Address: " + remoteAddress);
    }

    @Override
    public void channelUnregistered(ChannelHandlerContext ctx) {
        String remoteAddress = ctx.channel().remoteAddress().toString();
        log.info("[CLOSED] Remote Address: " + remoteAddress);
    }


    @Override
    public void channelRead(ChannelHandlerContext ctx, Object data) {
        TransferOuterClass.Transfer trans = (TransferOuterClass.Transfer) data;

        // TODO 에러나면 다시 클라이언트로 에러메세지
        switch (trans.getType()) {
            case "msg":
                log.info("메세지 : {}", trans.getContent());
                // TODO 받기 보내기 테스트~
                String msg = messageService.receiveMessage(trans);
                messageService.sendMessage(trans, msg);
                break;
            case "room-in":
                roomService.roomIn(ctx.channel(), trans);
                break;
            case "room-out":
                roomService.roomOut(ctx.channel(), trans);
                break;
            case "seat-start":
                // TODO 자리양도
                String userId = trans.getUserId();
                log.info("자리양도 시작 : {}", userId);
                roomService.seatStart(trans);
                break;
            case "villain-on":
                roomService.villainOn(trans);
                break;
            case "villain-off":
                roomService.villainOff(trans);
                break;
            default:
                log.info("WRONG TYPE : {}", trans.getType());
                break;
        }
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
        // Close the connection when an exception is raised.
        ctx.close();
        cause.printStackTrace();
    }

}