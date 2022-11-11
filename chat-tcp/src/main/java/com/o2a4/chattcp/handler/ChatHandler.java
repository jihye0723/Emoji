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

        try {
            switch (trans.getType()) {
                case "msg":
                    log.info("msg in : {}", trans.getContent());
                    String msg = messageService.receiveMessage(trans);
                    log.info("msg filtered : {}", msg);
                    messageService.sendMessage(trans, msg);
                    break;
                case "room-in":
                    log.info("방 입장 : {}", trans.getUserId());
                    roomService.roomIn(ctx.channel(), trans);
                    break;
                case "room-out":
                    log.info("방 퇴장 : {}", trans.getUserId());
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
                    throw new IllegalArgumentException("잘못된 타입 전송");
            }
        }
        catch (RuntimeException e) {
            log.error("에러 발생! {}", e);
            messageService.sendMessageToOneByServer(trans, "error", "메세지 처리 또는 기능 동작에 문제가 발생했습니다");
        }
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
        // Close the connection when an exception is raised.
        ctx.close();
        cause.printStackTrace();
    }

}
