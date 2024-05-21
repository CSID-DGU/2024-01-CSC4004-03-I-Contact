package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.food;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UpdateFoodRequestDto {

    private String name;

    private Integer firstPrice;

    private Integer sellPrice;

    private Integer capacity;

}
