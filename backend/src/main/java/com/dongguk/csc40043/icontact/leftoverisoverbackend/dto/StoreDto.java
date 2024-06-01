package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.*;
import lombok.Builder;
import lombok.Data;

import java.time.LocalTime;
import java.util.List;

@Data
@Builder
public class StoreDto {

    private Long id;

    private Long ownerId;

    private Long categoryId;

    private String name;

    private LocalTime startTime;

    private LocalTime endTime;

    private String address;

    private String phone;

    private Double latitude;

    private Double longitude;

    private boolean isOpen;

    private boolean deleted;

    private List<Order> orders;

    private List<FavoriteStore> favoriteStores;

    private List<Food> foods;

    public Store toEntity(Member member) {
        return Store.builder()
                .id(id)
                .member(member)
                .categoryId(categoryId)
                .name(name)
                .startTime(startTime)
                .endTime(endTime)
                .address(address)
                .phone(phone)
                .latitude(latitude)
                .longitude(longitude)
                .isOpen(isOpen)
                .deleted(deleted)
                .orders(orders)
                .favoriteStores(favoriteStores)
                .foods(foods)
                .build();
    }

}
