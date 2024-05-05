package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Owner;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class OwnerDto {

    private Long id;

    private String username;

    private String name;

    private String password;

    private String email;

    private boolean isDeleted;

    private List<Store> stores = new ArrayList<>();

    public Owner toEntity() {
        return Owner.builder()
                .id(id)
                .username(username)
                .name(name)
                .password(password)
                .email(email)
                .isDeleted(isDeleted)
                .stores(stores)
                .build();
    }

}
