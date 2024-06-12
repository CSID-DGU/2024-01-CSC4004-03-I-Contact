package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.GetFoodListResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.OrderListDto;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class WebSocketService {

    private final SimpMessagingTemplate simpMessagingTemplate;

    public void sendFoodUpdate(Long storeId, List<GetFoodListResponseDto> foodList) {
        simpMessagingTemplate.convertAndSend("/topic/store/" + storeId.toString(), foodList);
    }

    public void sendAllFoodUpdate(Long storeId, List<GetFoodListResponseDto> foodList) {
        simpMessagingTemplate.convertAndSend("/topic/store/" + storeId.toString() + "/all", foodList);
    }

    public void sendOrderUpdate(Long storeId, List<OrderListDto> orderList) {
        simpMessagingTemplate.convertAndSend("/topic/order/" + storeId, orderList);
    }

}
