package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.store;

import lombok.Data;

@Data
public class UpdateStoreRequestDto {

    private String name;

    private String startTime;

    private String endTime;

    private String address;

    private String phone;

    private Long categoryId;

}
