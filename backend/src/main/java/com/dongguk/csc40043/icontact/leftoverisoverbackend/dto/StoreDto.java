package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.*;
import lombok.Data;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Data
public class StoreDto {

    private Long id;

    private Owner owner;

    private String name;

    private LocalTime startTime;

    private LocalTime endTime;

    private String address;

    private String phone;

    private boolean isDeleted;

    private List<Order> orders = new ArrayList<>();

    private List<FavoriteStore> favoriteStores = new ArrayList<>();

    private List<Food> foods = new ArrayList<>();

    public Store toEntity() {
        return Store.builder()
                .id(id)
                .owner(owner)
                .name(name)
                .startTime(startTime)
                .endTime(endTime)
                .address(address)
                .phone(phone)
                .isDeleted(isDeleted)
                .orders(orders)
                .favoriteStores(favoriteStores)
                .foods(foods)
                .build();
    }


}
