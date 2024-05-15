package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.member;

import lombok.Data;

import java.util.List;

@Data
public class LoginRequestDto {

    private String username;

    private String password;

    private List<String> roles;

}
