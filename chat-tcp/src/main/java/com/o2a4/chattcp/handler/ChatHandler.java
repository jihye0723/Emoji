package com.o2a4.chattcp.handler;

import com.o2a4.chattcp.model.Seats;
import com.o2a4.chattcp.proto.TransferOuterClass;
import com.o2a4.chattcp.service.KafkaService;
import com.o2a4.chattcp.service.MessageService;
import com.o2a4.chattcp.service.RoomService;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelHandler;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundHandlerAdapter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.boot.autoconfigure.web.ServerProperties;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

@Slf4j
@Component
@ChannelHandler.Sharable
@RequiredArgsConstructor
public class ChatHandler extends ChannelInboundHandlerAdapter {
    private final RoomService roomService;
    private final MessageService messageService;
    private final KafkaService kafkaService;

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
    public void channelRead(ChannelHandlerContext ctx, Object data){
        TransferOuterClass.Transfer trans = (TransferOuterClass.Transfer) data;

        switch (trans.getType()) {
            case "msg":
                log.info("메세지 : {}", trans.getContent());
                // TODO 다시 클라이언트로 에러메세지
                String msg = messageService.receiveMessage(trans);
                messageService.sendMessage(trans, msg);

                /*kafka 로 메시지 전송 */
                JSONObject message= new JSONObject();
                message.put("userid", trans.getUserId()); // 사용자 ID
                message.put("content", trans.getContent()); // 메시지
                message.put("send_at", trans.getSendAt());  // 전송 시간
                String chats = message.toString();
                kafkaService.send(chats);

                break;
            case "room-in":
                roomService.roomIn(ctx.channel(), trans);
                break;
            case "room-out":
                roomService.roomOut(ctx.channel(), trans);
                break;
            case "seat-start":
                String userId = trans.getUserId();
                log.info("자리양도 시작 : {}", userId);
//                String winnerId= roomService.seatStart(userId).toString();
//                Mono<String> string  = roomService.seatStart(userId);
//                log.info("뭐임 ? " , seats)
//                log.info("자리양도 당첨 : {}",  winnerId);

//                if(winnerId!=null){
//                }

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