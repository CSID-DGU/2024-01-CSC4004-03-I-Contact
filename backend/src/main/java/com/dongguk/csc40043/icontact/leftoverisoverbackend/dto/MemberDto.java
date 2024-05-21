package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.FavoriteStore;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Member;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Order;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Data
@Builder
public class MemberDto {

    private Long id;

    private String username;

    private String name;

    private String password;

    private String email;

    private boolean deleted;

    @Builder.Default
    private List<Order> orders = new ArrayList<>();

    @Builder.Default
    private List<FavoriteStore> favoriteStores = new ArrayList<>();

    @Builder.Default
    private List<Store> stores = new ArrayList<>();

    @Builder.Default
    private List<String> roles = new ArrayList<>();

    public Member toEntity() {
        return Member.builder()
                .id(id)
                .username(username)
                .name(name)
                .password(password)
                .email(email)
                .deleted(deleted)
                .orders(orders)
                .favoriteStores(favoriteStores)
                .stores(stores)
                .roles(roles)
                .build();
    }

}
