package com.dongguk.csc40043.icontact.leftoverisoverbackend.controller;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.food.AddFoodRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.food.UpdateFoodRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.service.FoodService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequiredArgsConstructor
@Tag(name = "Food", description = "음식 API")
public class FoodController {

    private final FoodService foodService;

    @PostMapping(value = "/food", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "음식 추가", description = "음식을 추가합니다.")
    public ResponseEntity<?> addFood(@RequestParam("name") String name,
                                     @RequestParam("firstPrice") int firstPrice,
                                     @RequestParam("sellPrice") int sellPrice,
                                     @RequestPart(value = "file", required = false) MultipartFile file) {
        try {
            AddFoodRequestDto addFoodRequestDto = AddFoodRequestDto.builder()
                    .name(name)
                    .firstPrice(firstPrice)
                    .sellPrice(sellPrice)
                    .build();
            return ResponseEntity.status(HttpStatus.OK).body(foodService.addFood(addFoodRequestDto, file));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/food")
    @Operation(summary = "음식 조회", description = "음식 리스트를 조회합니다.")
    public ResponseEntity<?> getFoodList() {
        try {
            return ResponseEntity.ok(foodService.getFoodList());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PatchMapping(value = "/food/{foodId}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "음식 수정", description = "특정 음식을 수정합니다.")
    public ResponseEntity<?> updateFood(@PathVariable("foodId") Long id,
                                        @RequestParam(value = "name", required = false) String name,
                                        @RequestParam(value = "firstPrice", required = false) Integer firstPrice,
                                        @RequestParam(value = "sellPrice", required = false) Integer sellPrice,
                                        @RequestParam(value = "capacity", required = false) Integer capacity,
                                        @RequestParam(value = "isVisible", required = false) Boolean isVisible,
                                        @RequestPart(required = false) MultipartFile file) {
        try {
            UpdateFoodRequestDto updateFoodRequestDto = UpdateFoodRequestDto.builder()
                    .name(name)
                    .firstPrice(firstPrice)
                    .sellPrice(sellPrice)
                    .capacity(capacity)
                    .isVisible(isVisible)
                    .build();
            foodService.updateFood(id, updateFoodRequestDto, file);
            return ResponseEntity.ok("Successfully updated food");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/food/store/{storeId}")
    @Operation(summary = "가게별 음식 조회", description = "특정 가게의 음식 리스트를 조회합니다.")
    public ResponseEntity<?> getFoodListByStoreId(@PathVariable("storeId") Long storeId) {
        try {
            return ResponseEntity.ok(foodService.getFoodListByStoreId(storeId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/food/{foodId}")
    public ResponseEntity<?> deleteFood(@PathVariable("foodId") Long foodId) {
        try {
            foodService.deleteFood(foodId);
            return ResponseEntity.ok("Successfully deleted food");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/food/{foodId}/add")
    @Operation(summary = "음식 수량 추가", description = "음식의 수량을 추가합니다.")
    public ResponseEntity<?> addFoodCapacity(@PathVariable("foodId") Long foodId) {
        try {
            foodService.addFoodCapacity(foodId);
            return ResponseEntity.ok("Successfully added food count");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/food/{foodId}/minus")
    @Operation(summary = "음식 수량 감소", description = "음식의 수량을 감소합니다.")
    public ResponseEntity<?> minusFoodCapacity(@PathVariable("foodId") Long foodId) {
        try {
            foodService.minusFoodCapacity(foodId);
            return ResponseEntity.ok("Successfully minus food count");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}
