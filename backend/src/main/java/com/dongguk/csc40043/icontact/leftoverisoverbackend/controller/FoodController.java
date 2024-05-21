package com.dongguk.csc40043.icontact.leftoverisoverbackend.controller;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.food.AddFoodRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.food.UpdateFoodRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.service.FoodService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class FoodController {

    private final FoodService foodService;

    @PostMapping("/food")
    public ResponseEntity<?> addFood(@RequestBody AddFoodRequestDto addFoodRequestDto) {
        try {
            return ResponseEntity.status(HttpStatus.CREATED).body(foodService.addFood(addFoodRequestDto));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/food")
    public ResponseEntity<?> getFoodList() {
        try {
            return ResponseEntity.ok(foodService.getFoodList());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PatchMapping("/food/{foodId}")
    public ResponseEntity<?> updateFood(@PathVariable("foodId") Long id, @RequestBody UpdateFoodRequestDto updateFoodRequestDto) {
        try {
            foodService.updateFood(id, updateFoodRequestDto);
            return ResponseEntity.ok("Successfully updated food");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}