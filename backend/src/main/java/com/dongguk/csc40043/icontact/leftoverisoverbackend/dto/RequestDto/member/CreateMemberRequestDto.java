package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.member;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.MemberDto;
import lombok.Data;

import java.util.List;

@Data
public class CreateMemberRequestDto {

    private String username;

    private String name;

    private String email;

    private String password;

    private List<String> roles;

    public MemberDto toServiceDto(String encodedPassword, List<String> roles) {
        return MemberDto.builder()
                .username(username)
                .name(name)
                .email(email)
                .password(encodedPassword)
                .roles(roles)
                .build();
    }

}
