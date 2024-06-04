package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.common.SecurityUtil;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.*;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.order.CreateOrderRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.CreateOrderResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.time.LocalDateTime;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final StoreRepository storeRepository;
    private final MemberRepository memberRepository;
    private final FoodRepository foodRepository;
    private final FcmService fcmService;

    @Transactional
    public CreateOrderResponseDto createOrder(CreateOrderRequestDto createOrderRequestDto) {
        if (!createOrderRequestDto.getAppPay()) {
            Member member = memberRepository.findByUsernameAndDeleted(SecurityUtil.getCurrentUser(), false)
                    .orElseThrow(() -> new IllegalArgumentException("해당 회원이 존재하지 않습니다."));
            Store store = storeRepository.findByIdAndDeleted(createOrderRequestDto.getStoreId(), false)
                    .orElseThrow(() -> new IllegalArgumentException("해당 가게가 존재하지 않습니다."));
            Order order = createOrderRequestDto.toEntity(member, store, LocalDateTime.now());
            createOrderRequestDto.getOrderFoodDtos().forEach(orderFoodDto -> {
                Food food = foodRepository.findById(orderFoodDto.getFoodId())
                        .orElseThrow(() -> new IllegalArgumentException("해당 음식이 존재하지 않습니다."));
                if (food.getCapacity() < orderFoodDto.getCount()) {
                    throw new IllegalArgumentException("재고가 부족합니다.");
                }
                OrderFood orderFood = OrderFood.builder()
                        .food(food)
                        .count(orderFoodDto.getCount())
                        .build();
                order.addOrderFood(orderFood);
                food.minusCapacity(orderFoodDto.getCount());
            });
            orderRepository.save(order);
            return CreateOrderResponseDto.builder()
                    .orderId(order.getId())
                    .build();
        } else {
            throw new IllegalArgumentException("앱 결제는 아직 지원하지 않습니다.");
        }
    }

    public void sendOrderNotification(Long orderId) {
        orderRepository.findById(orderId)
                .ifPresent(order -> {
                    String title = "새로운 주문이 도착했습니다.";
                    String body = "새로운 주문이 도착했습니다.";
                    try {
                        fcmService.sendMessageTo(order.getStore().getMember().getFcmToken(), title, body);
                    } catch (IOException e) {
                        throw new IllegalArgumentException("푸시 알림을 보내는데 실패했습니다.");
                    }
                });
    }
    
}
