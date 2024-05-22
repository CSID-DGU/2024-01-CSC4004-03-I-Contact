package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.food;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Food;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import lombok.Data;

@Data
public class AddFoodRequestDto {

    private String name;

    private int firstPrice;

    private int sellPrice;

    public Food toEntity(Store store) {
        return Food.builder()
                .name(name)
                .store(store)
                .firstPrice(firstPrice)
                .sellPrice(sellPrice)
                .build();
    }

}
