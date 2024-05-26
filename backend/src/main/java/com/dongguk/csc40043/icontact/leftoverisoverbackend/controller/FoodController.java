package com.dongguk.csc40043.icontact.leftoverisoverbackend.controller;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.food.AddFoodRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.food.UpdateFoodRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.service.FoodService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@Tag(name = "Food", description = "음식 API")
public class FoodController {

    private final FoodService foodService;

    @PostMapping("/food")
    @Operation(summary = "음식 추가", description = "음식을 추가합니다.")
    public ResponseEntity<?> addFood(@RequestBody AddFoodRequestDto addFoodRequestDto) {
        try {
            return ResponseEntity.status(HttpStatus.OK).body(foodService.addFood(addFoodRequestDto));
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

    @PatchMapping("/food/{foodId}")
    @Operation(summary = "음식 수정", description = "특정 음식을 수정합니다.")
    public ResponseEntity<?> updateFood(@PathVariable("foodId") Long id, @RequestBody UpdateFoodRequestDto updateFoodRequestDto) {
        try {
            foodService.updateFood(id, updateFoodRequestDto);
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

}
