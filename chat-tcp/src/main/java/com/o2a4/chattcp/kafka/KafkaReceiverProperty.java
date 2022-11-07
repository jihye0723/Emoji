package com.o2a4.chattcp.kafka;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class KafkaReceiverProperty {

    // Receiver 이름
    private String name;

    // topic 이름
    private String topic;

    // receiver 그룹 아이디
    private String groupId;

}
