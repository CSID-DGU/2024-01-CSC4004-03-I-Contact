package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.food;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Food;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Image;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AddFoodRequestDto {

    private String name;

    private int firstPrice;

    private int sellPrice;

    public Food toEntity(Store store, Image image) {
        return Food.builder()
                .name(name)
                .store(store)
                .firstPrice(firstPrice)
                .sellPrice(sellPrice)
                .image(image)
                .build();
    }

}
