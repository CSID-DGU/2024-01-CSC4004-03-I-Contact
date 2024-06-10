package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.member;

import lombok.Data;

@Data
public class FindUsernameRequestDto {

    private String name;

    private String email;

    private String phone;

}
