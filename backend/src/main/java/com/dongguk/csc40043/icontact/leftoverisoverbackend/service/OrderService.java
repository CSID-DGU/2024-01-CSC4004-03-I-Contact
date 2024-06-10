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
import java.time.format.DateTimeFormatter;
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
        if (!status.equals("VISIT") && !status.equals("ALL")) {
            throw new IllegalArgumentException("Invalid status");
        }
        List<Order> orderList = orderRepository.findByStoreAndStatus(store, OrderStatus.valueOf(status));
        if (status.equals("ALL")) {
            List<Order> orderAllList = orderRepository.findByStoreAndStatus(store, OrderStatus.valueOf("ORDER"));
            orderList.addAll(orderAllList);
        }
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
        Food food = foodRepository.findById(createOrderRequestDto.getOrderFoodDtos().get(0).getFoodId())
                .orElseThrow(() -> new IllegalArgumentException("해당 음식이 존재하지 않습니다."));
        String messageTitle = "새로운 주문이 들어왔습니다.";
        String messageBody;
        int orderFoodCount = createOrderRequestDto.getOrderFoodDtos().size();
        if (orderFoodCount > 1) {
            messageBody = food.getName();
        } else {
            messageBody = food.getName() + " 외 " + (orderFoodCount - 1) + "개의 음식";
        }
        fcmService.sendMessageTo("owner", store.getMember().getFcmToken(), messageTitle, messageBody);
    }

    private OrderListDto mapToOrderListDto(Order order, Member member) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return OrderListDto.builder()
                .customer(mapToCustomerDto(member))
                .store(mapToOrderStoreDto(order.getStore()))
                .orderDate(order.getOrderDate().format(formatter))
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

    private OrderListDto.OrderStore mapToOrderStoreDto(Store store) {
        return OrderListDto.OrderStore.builder()
                .storeId(store.getId())
                .name(store.getName())
                .build();
    }

    private List<OrderListDto.Food> mapToOrderFoodDtos(List<OrderFood> orderFoods) {
        return orderFoods.stream()
                .map(orderFood -> OrderListDto.Food.builder()
                        .name(orderFood.getFood().getName())
                        .count(orderFood.getCount())
                        .imageUrl(orderFood.getFood().getImage() != null ? orderFood.getFood().getImage().getFileUrl() : "")
                        .build()
                )
                .collect(Collectors.toList());
    }

}
