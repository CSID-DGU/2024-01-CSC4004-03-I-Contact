package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.common.SecurityUtil;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.*;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.order.ChangeOrderRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.order.CreateOrderRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.CreateOrderResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.OrderListDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

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

    public List<OrderListDto> getCustomerOrder() {
        Member member = memberRepository.findByUsernameAndDeleted(SecurityUtil.getCurrentUser(), false)
                .orElseThrow(() -> new IllegalArgumentException("해당 회원이 존재하지 않습니다."));
        List<Order> orderList = orderRepository.findByMember(member);
        return orderList.stream()
                .map(order -> mapToOrderListDto(order, member))
                .collect(Collectors.toList());
    }

    public List<OrderListDto> getOwnerOrder(String status) {
        Store store = storeRepository.findByMemberAndDeleted(memberRepository.findByUsernameAndDeleted(SecurityUtil.getCurrentUser(), false)
                        .orElseThrow(() -> new IllegalArgumentException("해당 회원이 존재하지 않습니다.")), false)
                .orElseThrow(() -> new IllegalArgumentException("해당 가게가 존재하지 않습니다."));
        List<Order> orderList = orderRepository.findByStoreAndStatus(store, OrderStatus.valueOf(status));
        return orderList.stream()
                .map(order -> mapToOrderListDto(order, order.getMember()))
                .collect(Collectors.toList());
    }

    @Transactional
    public void cancelOrder(ChangeOrderRequestDto changeOrderRequestDto) {
        Order order = orderRepository.findById(changeOrderRequestDto.getOrderId())
                .orElseThrow(() -> new IllegalArgumentException("해당 주문이 존재하지 않습니다."));
        order.cancel();
    }

    @Transactional
    public void completeOrder(ChangeOrderRequestDto changeOrderRequestDto) {
        Order order = orderRepository.findById(changeOrderRequestDto.getOrderId())
                .orElseThrow(() -> new IllegalArgumentException("해당 주문이 존재하지 않습니다."));
        order.complete();
    }

    public void sendOrderNotification(CreateOrderRequestDto createOrderRequestDto) throws IOException {
        Store store = storeRepository.findByIdAndDeleted(createOrderRequestDto.getStoreId(), false)
                .orElseThrow(() -> new IllegalArgumentException("해당 가게가 존재하지 않습니다."));
        fcmService.sendMessageTo(store.getMember().getFcmToken(), "새로운 주문이 도착했습니다.", "새로운 주문이 도착했습니다.");
    }

    private OrderListDto mapToOrderListDto(Order order, Member member) {
        return OrderListDto.builder()
                .customer(mapToCustomerDto(member))
                .orderDate(order.getOrderDate().toString())
                .status(order.getStatus().name())
                .orderNum(order.getId())
                .appPay(order.getAppPay())
                .orderFood(mapToOrderFoodDtos(order.getOrderFoods()))
                .build();
    }

    private OrderListDto.Customer mapToCustomerDto(Member member) {
        return OrderListDto.Customer.builder()
                .username(member.getUsername())
                .phone(member.getPhone())
                .email(member.getEmail())
                .build();
    }

    private List<OrderListDto.Food> mapToOrderFoodDtos(List<OrderFood> orderFoods) {
        return orderFoods.stream()
                .map(orderFood -> OrderListDto.Food.builder()
                        .name(orderFood.getFood().getName())
                        .count(orderFood.getCount())
                        .build()
                )
                .collect(Collectors.toList());
    }

}
