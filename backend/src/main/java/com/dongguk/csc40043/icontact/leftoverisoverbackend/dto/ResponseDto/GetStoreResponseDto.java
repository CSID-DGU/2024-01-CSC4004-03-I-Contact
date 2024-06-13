package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class GetStoreResponseDto {

    Long storeId;

    Long ownerId;

    Long categoryId;

    String name;

    String startTime;

    String endTime;

    String address;

    String phone;

    Double latitude;

    Double longitude;

    boolean isOpen;

    boolean deleted;

}