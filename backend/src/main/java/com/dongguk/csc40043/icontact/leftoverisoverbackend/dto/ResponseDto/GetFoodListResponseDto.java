package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class GetFoodListResponseDto {

    Long foodId;

    Long storeId;

    String name;

    int firstPrice;

    int sellPrice;

    int capacity;

    int visits;

    boolean isVisible;

    boolean deleted;

}
