package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Owner;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
public class OwnerDto {

    private Long id;

    private String username;

    private String name;

    private String password;

    private String email;

    private boolean isDeleted = false;

    private List<Store> stores = new ArrayList<>();

    public OwnerDto(String username, String name, String email, String password) {
        this.username = username;
        this.name = name;
        this.email = email;
        this.password = password;
    }

    public Owner toEntity(PasswordEncoder passwordEncoder) {
        return Owner.builder()
                .id(id)
                .username(username)
                .name(name)
                .password(passwordEncoder.encode(password))
                .email(email)
                .isDeleted(isDeleted)
                .stores(stores)
                .build();
    }

}
