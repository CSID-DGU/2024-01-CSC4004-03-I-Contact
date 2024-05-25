package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.favorite;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.FavoriteStore;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Member;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import lombok.Data;

@Data
public class AddFavoriteRequestDto {

    private Long storeId;

    public FavoriteStore toEntity(Member member, Store store) {
        return FavoriteStore.builder()
                .member(member)
                .store(store)
                .build();
    }

}
