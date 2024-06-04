package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.FcmMessageDto;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.common.net.HttpHeaders;
import lombok.extern.slf4j.Slf4j;
import okhttp3.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.List;

@Service
@Slf4j
public class FcmService {

    @Value("${FIREBASE_CONFIG_BASE64}")
    private String firebaseConfigBase64;

    @Value("${FIREBASE_ALARM_SEND_API_URI}")
    private String FIREBASE_ALARM_SEND_API_URI;

    private final ObjectMapper objectMapper;

    @Autowired
    public FcmService(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    private String getAccessToken() throws IOException {
        byte[] decodedBytes = Base64.getDecoder().decode(firebaseConfigBase64);
        GoogleCredentials googleCredentials = GoogleCredentials
                .fromStream(new ByteArrayInputStream(decodedBytes))
                .createScoped(List.of("https://www.googleapis.com/auth/cloud-platform"));
        googleCredentials.refreshIfExpired();
        return googleCredentials.getAccessToken().getTokenValue();
    }

    /**
     * makeMessage : 알림 파라미터들을 FCM이 요구하는 body 형태로 가공한다.
     *
     * @param targetToken : firebase token
     * @param title       : 알림 제목
     * @param body        : 알림 내용
     * @return
     */
    public String makeMessage(String targetToken, String title, String body) throws JsonProcessingException {
        FcmMessageDto fcmMessageDto = FcmMessageDto.builder()
                .message(
                        FcmMessageDto.Message.builder()
                                .token(targetToken)
                                .notification(
                                        FcmMessageDto.Notification.builder()
                                                .title(title)
                                                .body(body)
                                                .build()
                                )
                                .build()
                )
                .validateOnly(false)
                .build();
        return objectMapper.writeValueAsString(fcmMessageDto);
    }

    /**
     * 알림 푸쉬를 보내는 역할을 하는 메서드
     *
     * @param targetToken : 푸쉬 알림을 받을 클라이언트 앱의 식별 토큰
     */
    public void sendMessageTo(String targetToken, String title, String body) throws IOException {
        String message = makeMessage(targetToken, title, body);
        OkHttpClient client = new OkHttpClient();
        RequestBody requestBody = RequestBody.create(message, MediaType.get("application/json; charset=utf-8"));
        Request request = new Request.Builder()
                .url(FIREBASE_ALARM_SEND_API_URI)
                .post(requestBody)
                .addHeader(HttpHeaders.AUTHORIZATION, "Bearer " + getAccessToken())
                .addHeader(HttpHeaders.CONTENT_TYPE, "application/json; charset=utf-8")
                .build();
        Response response = client.newCall(request).execute();
        log.info(response.body().string());

    }

}
