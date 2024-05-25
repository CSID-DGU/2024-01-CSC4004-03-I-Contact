package com.dongguk.csc40043.icontact.leftoverisoverbackend.controller;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.common.SecurityUtil;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.store.CreateStoreRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.store.UpdateStoreRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.service.StoreService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@Tag(name = "Store", description = "가게 API")
public class StoreController {

    private final StoreService storeService;

    @PostMapping("/store")
    @Operation(summary = "가게 생성", description = "가게를 생성합니다.")
    public ResponseEntity<?> createStore(@RequestBody CreateStoreRequestDto createStoreRequestDto) {
        try {
            return ResponseEntity.status(HttpStatus.CREATED).body(storeService.createStore(createStoreRequestDto));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/store")
    @Operation(summary = "가게 조회", description = "가게 리스트를 조회합니다.")
    public ResponseEntity<?> getStore() {
        try {
            String username = SecurityUtil.getCurrentUser();
            return ResponseEntity.ok(storeService.getStore(username));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/store/open")
    @Operation(summary = "가게 오픈", description = "가게를 오픈합니다.")
    public ResponseEntity<?> openStore() {
        try {
            storeService.changeOpenStatus(SecurityUtil.getCurrentUser());
            return ResponseEntity.ok("Successfully changed open status");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/store/keyword/{keyword}")
    @Operation(summary = "키워드로 가게 조회", description = "키워드로 가게를 조회합니다.")
    public ResponseEntity<?> getStoreByKeyword(@PathVariable("keyword") String keyword) {
        try {
            return ResponseEntity.ok(storeService.getStoreByKeyword(keyword));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/store/category/{categoryId}")
    @Operation(summary = "카테고리별 가게 조회", description = "카테고리별 가게를 조회합니다.")
    public ResponseEntity<?> getStoreByCategory(@PathVariable("categoryId") Long categoryId) {
        try {
            return ResponseEntity.ok(storeService.getStoreByCategory(categoryId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PatchMapping("/store/{storeId}")
    @Operation(summary = "가게 수정", description = "특정 가게를 수정합니다.")
    public ResponseEntity<?> updateStore(@PathVariable("storeId") Long storeId, @RequestBody UpdateStoreRequestDto updateStoreRequestDto) {
        try {
            storeService.updateStore(storeId, updateStoreRequestDto);
            return ResponseEntity.ok("Successfully updated store");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/store/{storeId}")
    @Operation(summary = "가게 조회", description = "특정 가게를 조회합니다.")
    public ResponseEntity<?> getStore(@PathVariable("storeId") Long storeId) {
        try {
            return ResponseEntity.ok(storeService.getStore(storeId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}
