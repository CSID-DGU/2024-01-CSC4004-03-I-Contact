package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class FindUsernameResponseDto {

    private Long memberId;

    private String role;

    private String username;

}
