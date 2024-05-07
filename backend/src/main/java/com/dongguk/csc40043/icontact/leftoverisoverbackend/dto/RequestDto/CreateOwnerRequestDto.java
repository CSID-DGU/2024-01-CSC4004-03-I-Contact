package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto;

import lombok.Data;

@Data
public class CreateOwnerRequestDto {

    private String username;

    private String name;

    private String email;

    private String password;

}
