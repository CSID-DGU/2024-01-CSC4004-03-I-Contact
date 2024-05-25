package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class GetMemberResponseDto {

    private String username;

    private String name;

    private String email;

}
