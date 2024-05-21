package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.common.SecurityUtil;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Food;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Member;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.food.AddFoodRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.AddFoodResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.GetFoodListResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.FoodRepository;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.MemberRepository;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.StoreRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class FoodService {

    private final FoodRepository foodRepository;
    private final MemberRepository memberRepository;
    private final StoreRepository storeRepository;

    @Transactional
    public AddFoodResponseDto addFood(AddFoodRequestDto addFoodRequestDto) {
        Member member = memberRepository.findByUsernameAndDeleted(SecurityUtil.getCurrentUser(), false);
        Store store = storeRepository.findByMemberAndDeleted(member, false);
        Food food = foodRepository.save(addFoodRequestDto.toEntity(store));
        return AddFoodResponseDto.builder()
                .foodId(food.getId())
                .build();
    }

    public List<GetFoodListResponseDto> getFoodList() {
        Member member = memberRepository.findByUsernameAndDeleted(SecurityUtil.getCurrentUser(), false);
        Store store = storeRepository.findByMemberAndDeleted(member, false);
        return store.getFoods().stream()
                .map(food -> GetFoodListResponseDto.builder()
                        .foodId(food.getId())
                        .storeId(store.getId())
                        .name(food.getName())
                        .firstPrice(food.getFirstPrice())
                        .sellPrice(food.getSellPrice())
                        .capacity(food.getCapacity())
                        .visits(food.getVisits())
                        .isVisible(food.isVisible())
                        .deleted(food.isDeleted())
                        .build()
                )
                .collect(Collectors.toList());
    }

}
