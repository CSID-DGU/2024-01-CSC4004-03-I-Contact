package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto;

import lombok.Data;

@Data
public class CreateStoreRequestDto {

    private Long ownerId;

    private String name;

    private String startTime;

    private String endTime;

    private String address;

    private String phone;

}
