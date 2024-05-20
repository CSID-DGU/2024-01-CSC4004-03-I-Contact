package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.store;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Category;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Member;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.StoreDto;
import lombok.Data;

import java.time.LocalTime;

@Data
public class CreateStoreRequestDto {

    private String name;

    private String startTime;

    private String endTime;

    private String address;

    private String phone;

    private Long categoryId;

    public StoreDto toServiceDto(Member member, Category category) {
        return StoreDto.builder()
                .name(name)
                .startTime(LocalTime.parse(startTime))
                .endTime(LocalTime.parse(endTime))
                .address(address)
                .phone(phone)
                .categoryId(categoryId)
                .build();
    }

}
