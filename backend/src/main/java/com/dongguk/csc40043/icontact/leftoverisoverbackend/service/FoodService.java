package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.common.SecurityUtil;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Food;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Image;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Member;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.food.AddFoodRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.food.UpdateFoodRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.AddFoodResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.GetFoodListResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.FoodRepository;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.MemberRepository;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.StoreRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class FoodService {

    private final FoodRepository foodRepository;
    private final MemberRepository memberRepository;
    private final StoreRepository storeRepository;
    private final ImageService imageService;

    @Transactional
    public AddFoodResponseDto addFood(AddFoodRequestDto addFoodRequestDto, MultipartFile file) throws IOException {
        Member member = memberRepository.findByUsernameAndDeleted(SecurityUtil.getCurrentUser(), false).orElseThrow(() ->
                new UsernameNotFoundException("존재하지 않는 회원입니다."));
        Store store = storeRepository.findByMemberAndDeleted(member, false).orElseThrow(() ->
                new IllegalArgumentException("존재하지 않는 식당입니다."));
        Image image = imageService.store(file);
        Food food = foodRepository.save(addFoodRequestDto.toEntity(store, image));
        return AddFoodResponseDto.builder()
                .foodId(food.getId())
                .build();
    }

    public List<GetFoodListResponseDto> getFoodList() {
        Member member = memberRepository.findByUsernameAndDeleted(SecurityUtil.getCurrentUser(), false).orElseThrow(() ->
                new UsernameNotFoundException("존재하지 않는 회원입니다."));
        Store store = storeRepository.findByMemberAndDeleted(member, false).orElseThrow(() ->
                new IllegalArgumentException("존재하지 않는 식당입니다."));
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
                        .imageUrl(food.getImage() != null ? food.getImage().getFileUrl() : null)
                        .build()
                )
                .collect(Collectors.toList());
    }

    @Transactional
    public void updateFood(Long foodId, UpdateFoodRequestDto updateFoodRequestDto, MultipartFile file) throws IOException {
        Food food = foodRepository.findById(foodId).orElseThrow(() ->
                new IllegalArgumentException("Invalid foodId"));
        if (updateFoodRequestDto.getName() != null)
            food.updateName(updateFoodRequestDto.getName());
        if (updateFoodRequestDto.getFirstPrice() != null)
            food.updateFirstPrice(updateFoodRequestDto.getFirstPrice());
        if (updateFoodRequestDto.getSellPrice() != null)
            food.updateSellPrice(updateFoodRequestDto.getSellPrice());
        if (updateFoodRequestDto.getCapacity() != null)
            food.updateCapacity(updateFoodRequestDto.getCapacity());
        if (updateFoodRequestDto.getIsVisible() != null)
            food.updateIsVisible(updateFoodRequestDto.getIsVisible());
        if (file != null) {
            Image image = imageService.store(file);
            food.updateImage(image);
        }
    }

    public List<GetFoodListResponseDto> getFoodListByStoreId(Long storeId) {
        Store store = storeRepository.findByIdAndDeleted(storeId, false).orElseThrow(() ->
                new IllegalArgumentException("Invalid storeId"));
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
                        .imageUrl(food.getImage() != null ? food.getImage().getFileUrl() : null)
                        .build()
                )
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteFood(Long foodId) {
        Food food = foodRepository.findById(foodId).orElseThrow(() ->
                new IllegalArgumentException("Invalid foodId"));
        foodRepository.delete(food);
    }

}
