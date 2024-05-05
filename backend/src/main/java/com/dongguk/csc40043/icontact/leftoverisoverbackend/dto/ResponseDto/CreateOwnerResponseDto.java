package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto;

import lombok.Data;

@Data
public class CreateOwnerResponseDto {

    private Long id;

    public CreateOwnerResponseDto(Long id) {
        this.id = id;
    }

}
