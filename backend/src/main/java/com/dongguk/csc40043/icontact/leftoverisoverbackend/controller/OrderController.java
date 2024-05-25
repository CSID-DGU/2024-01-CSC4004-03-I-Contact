package com.dongguk.csc40043.icontact.leftoverisoverbackend.controller;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.order.CreateOrderRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    @PostMapping("/order")
    public ResponseEntity<?> createOrder(@RequestBody CreateOrderRequestDto createOrderRequestDto) {
        try {

            return ResponseEntity.ok().body(orderService.createOrder(createOrderRequestDto));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}
