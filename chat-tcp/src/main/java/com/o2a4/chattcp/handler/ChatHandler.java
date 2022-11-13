package com.o2a4.chattcp.handler;

import com.o2a4.chattcp.model.Seats;
import com.o2a4.chattcp.proto.TransferOuterClass;
import com.o2a4.chattcp.repository.ChannelIdChannelRepository;
import com.o2a4.chattcp.repository.TrainChannelGroupRepository;
import com.o2a4.chattcp.service.KafkaService;
import com.o2a4.chattcp.service.MessageService;
import com.o2a4.chattcp.service.RoomService;
import io.netty.channel.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.data.redis.core.ReactiveRedisTemplate;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@Component
@ChannelHandler.Sharable
@RequiredArgsConstructor
public class ChatHandler extends ChannelInboundHandlerAdapter {
    private final RoomService roomService;
    private final MessageService messageService;
    private final KafkaService kafkaService;

//    private final ReactiveRedisTemplate<String, String> redisTemplate;
//    private final TrainChannelGroupRepository tcgRepo;
//    private final ChannelIdChannelRepository cidcRepo;
//
//    static String uPrefix = "user:";
//    static String cPrefix = "channel:";

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
/*        ChannelFuture closeFuture = ctx.channel().closeFuture();
        closeFuture.addListener(new ChannelFutureListener() {
            @Override
            public void operationComplete(ChannelFuture future) throws Exception {
                if (tcgRepo.getTrainChannelGroupMap().get(cg).size() == 0) {
                    redisTemplate.opsForHash().delete(tPrefix+cg).subscribe();
                }
            }
        })*/

        String remoteAddress = ctx.channel().remoteAddress().toString();
        log.info("[OPEN] Remote Address: " + remoteAddress);
//        ctx.channel().closeFuture().addListeners();
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

                    /*kafka 로 메시지 전송 */
                    JSONObject message= new JSONObject();
                    message.put("userid", trans.getUserId()); // 사용자 ID
                    message.put("content", trans.getContent()); // 메시지
                    message.put("send_at", trans.getSendAt());  // 전송 시간
                    String chats = message.toString();
                    kafkaService.send(chats);

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
                    String place = trans.getContent();
                    Map<String ,String > amap = new HashMap<>();
                    amap.put(userId, place);

                    log.info("자리양도 시작 : {}", userId);
                    Mono<String> res = roomService.seatStart(userId);
                    res.subscribe();

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
