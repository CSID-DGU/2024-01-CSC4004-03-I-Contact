package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.common.SecurityUtil;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.*;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.food.AddFoodRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.food.UpdateFoodRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.AddFoodResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.GetFoodListResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class FoodService {

    private final FoodRepository foodRepository;
    private final MemberRepository memberRepository;
    private final StoreRepository storeRepository;
    private final ImageService imageService;
    private final WebSocketService webSocketService;
    private final OrderFoodRepository orderFoodRepository;
    private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
    private ScheduledFuture<?> scheduledFuture;

    @Transactional
    public AddFoodResponseDto addFood(AddFoodRequestDto addFoodRequestDto, MultipartFile file) throws IOException {
        Member member = memberRepository.findByUsernameAndDeleted(SecurityUtil.getCurrentUser(), false).orElseThrow(() ->
                new UsernameNotFoundException("존재하지 않는 회원입니다."));
        Store store = storeRepository.findByMemberAndDeleted(member, false).orElseThrow(() ->
                new IllegalArgumentException("존재하지 않는 식당입니다."));
        Image image = imageService.store(file);
        Food food = foodRepository.save(addFoodRequestDto.toEntity(store, image));
        List<GetFoodListResponseDto> updatedFoodList = getFoodListByStoreId(food.getStore().getId());
        webSocketService.sendFoodUpdate(food.getStore().getId(), updatedFoodList);
        List<GetFoodListResponseDto> updatedAllFoodList = getAllFoodListByStoreId(food.getStore().getId());
        webSocketService.sendAllFoodUpdate(food.getStore().getId(), updatedAllFoodList);
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
                        .imageUrl(food.getImage() != null ? food.getImage().getFileUrl() : "")
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
        scheduleWebSocketUpdate(food.getStore().getId());
    }

    // Helper method to schedule the WebSocket update
    private synchronized void scheduleWebSocketUpdate(Long storeId) {
        // Cancel any existing scheduled task
        if (scheduledFuture != null && !scheduledFuture.isDone()) {
            scheduledFuture.cancel(false);
        }

        // Schedule a new task to send the WebSocket update after a delay
        scheduledFuture = scheduler.schedule(() -> {
            try {
                List<GetFoodListResponseDto> updatedFoodList = getFoodListByStoreId(storeId);
                webSocketService.sendFoodUpdate(storeId, updatedFoodList);
                List<GetFoodListResponseDto> updatedAllFoodList = getAllFoodListByStoreId(storeId);
                webSocketService.sendAllFoodUpdate(storeId, updatedAllFoodList);
            } catch (Exception e) {
                // Handle exceptions (e.g., log them)
                e.printStackTrace();
            }
        }, 1000, TimeUnit.MILLISECONDS); // Adjust the delay as needed (500ms in this example)
    }

    public List<GetFoodListResponseDto> getFoodListByStoreId(Long storeId) {
        Store store = storeRepository.findByIdAndDeleted(storeId, false).orElseThrow(() ->
                new IllegalArgumentException("Invalid storeId"));
        return store.getFoods().stream()
                .filter(Food::isVisible)
                .map(food -> GetFoodListResponseDto.builder()
                        .foodId(food.getId())
                        .storeId(store.getId())
                        .name(food.getName())
                        .firstPrice(food.getFirstPrice())
                        .sellPrice(food.getSellPrice())
                        .capacity(food.getCapacity())
                        .visits(food.getVisits())
                        .isVisible(food.isVisible())
                        .imageUrl(food.getImage() != null ? food.getImage().getFileUrl() : "")
                        .build()
                )
                .collect(Collectors.toList());
    }

    public List<GetFoodListResponseDto> getAllFoodListByStoreId(Long storeId) {
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
                        .imageUrl(food.getImage() != null ? food.getImage().getFileUrl() : "")
                        .build()
                )
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteFood(Long foodId) {
        Food food = foodRepository.findById(foodId).orElseThrow(() ->
                new IllegalArgumentException("Invalid foodId"));
        orderFoodRepository.deleteAllByFood(food);
//        if (food.getImage() != null)
//            imageRepository.deleteById(food.getImage().getId());
        foodRepository.deleteById(food.getId());
        List<GetFoodListResponseDto> updatedFoodList = getFoodListByStoreId(food.getStore().getId());
        webSocketService.sendFoodUpdate(food.getStore().getId(), updatedFoodList);
        List<GetFoodListResponseDto> updatedAllFoodList = getAllFoodListByStoreId(food.getStore().getId());
        webSocketService.sendAllFoodUpdate(food.getStore().getId(), updatedAllFoodList);
    }

    @Transactional
    public void addFoodCapacity(Long foodId) {
        Food food = foodRepository.findById(foodId).orElseThrow(() ->
                new IllegalArgumentException("Invalid foodId"));
        food.addCapacity();
        List<GetFoodListResponseDto> updatedFoodList = getFoodListByStoreId(food.getStore().getId());
        webSocketService.sendFoodUpdate(food.getStore().getId(), updatedFoodList);
        List<GetFoodListResponseDto> updatedAllFoodList = getAllFoodListByStoreId(food.getStore().getId());
        webSocketService.sendAllFoodUpdate(food.getStore().getId(), updatedAllFoodList);
    }

    @Transactional
    public void minusFoodCapacity(Long foodId) {
        Food food = foodRepository.findById(foodId).orElseThrow(() ->
                new IllegalArgumentException("Invalid foodId"));
        food.minusCapacity();
        List<GetFoodListResponseDto> updatedFoodList = getFoodListByStoreId(food.getStore().getId());
        webSocketService.sendFoodUpdate(food.getStore().getId(), updatedFoodList);
        List<GetFoodListResponseDto> updatedAllFoodList = getAllFoodListByStoreId(food.getStore().getId());
        webSocketService.sendAllFoodUpdate(food.getStore().getId(), updatedAllFoodList);
    }

}
