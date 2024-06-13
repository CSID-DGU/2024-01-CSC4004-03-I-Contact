package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class FcmMessageDto {

    private boolean validateOnly;

    private Message message;

    @Builder
    @Data
    public static class Message {

        private Notification notification;

        private String token;

    }

    @Builder
    @Data
    public static class Notification {

        private String title;

        private String body;

    }

}
