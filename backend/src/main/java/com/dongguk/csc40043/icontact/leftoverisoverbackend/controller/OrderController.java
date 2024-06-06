package com.dongguk.csc40043.icontact.leftoverisoverbackend.controller;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.order.CreateOrderRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.order.ChangeOrderRequestDto;
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
            orderService.sendOrderNotification(createOrderRequestDto);
            return ResponseEntity.ok().body(createOrderResponseDto);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/order/cancel")
    @Operation(summary = "주문 취소", description = "주문을 취소합니다.")
    public ResponseEntity<?> cancelOrder(@RequestBody ChangeOrderRequestDto changeOrderRequestDto) {
        try {
            orderService.cancelOrder(changeOrderRequestDto);
            return ResponseEntity.ok().body("Successfully canceled order");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/order/complete")
    @Operation(summary = "주문 완료", description = "주문을 완료합니다.")
    public ResponseEntity<?> completeOrder(@RequestBody ChangeOrderRequestDto changeOrderRequestDto) {
        try {
            orderService.completeOrder(changeOrderRequestDto);
            return ResponseEntity.ok().body("Successfully completed order");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}
