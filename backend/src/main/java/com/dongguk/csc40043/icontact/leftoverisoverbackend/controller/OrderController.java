package com.dongguk.csc40043.icontact.leftoverisoverbackend.controller;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.order.CreateOrderRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.CreateOrderResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.service.OrderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Tag(name = "Order", description = "주문 API")
public class OrderController {

    private final OrderService orderService;

    @PostMapping("/order")
    @Operation(summary = "주문 생성", description = "주문을 생성합니다.")
    public ResponseEntity<?> createOrder(@RequestBody CreateOrderRequestDto createOrderRequestDto) {
        try {
            CreateOrderResponseDto createOrderResponseDto = orderService.createOrder(createOrderRequestDto);
            orderService.sendOrderNotification(createOrderResponseDto.getOrderId());
            return ResponseEntity.ok().body(createOrderResponseDto);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}
