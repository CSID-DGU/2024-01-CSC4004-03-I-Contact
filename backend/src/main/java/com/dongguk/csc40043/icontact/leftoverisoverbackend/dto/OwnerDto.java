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

    private boolean isDeleted;

    private List<Store> stores = new ArrayList<>();

}
