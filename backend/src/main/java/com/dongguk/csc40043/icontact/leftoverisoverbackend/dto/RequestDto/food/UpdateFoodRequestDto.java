package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.food;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UpdateFoodRequestDto {

    String name;

    Integer firstPrice;

    Integer sellPrice;

    Integer capacity;

}
