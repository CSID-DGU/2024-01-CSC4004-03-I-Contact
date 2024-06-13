package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.member;

import lombok.Data;

@Data
public class UpdateMemberRequestDto {

    private String username;

    private String email;

    private String phone;

    private String name;

    private String password;

}
