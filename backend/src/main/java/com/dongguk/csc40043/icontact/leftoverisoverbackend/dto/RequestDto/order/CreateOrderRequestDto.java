package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.order;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.*;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class CreateOrderRequestDto {

    private Long storeId;

    private Boolean appPay;

    @JsonProperty("food")
    private List<OrderFoodDto> orderFoodDtos;

    public Order toEntity(Member member, Store store, LocalDateTime orderDate) {
        return Order.builder()
                .member(member)
                .store(store)
                .orderDate(orderDate)
                .appPay(appPay)
                .status(OrderStatus.VISIT)
                .build();
    }

}
