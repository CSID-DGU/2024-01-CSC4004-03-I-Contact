package com.dongguk.csc40043.icontact.leftoverisoverbackend.controller;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.common.SecurityUtil;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.store.CreateStoreRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.store.UpdateStoreRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.service.StoreService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class StoreController {

    private final StoreService storeService;

    @PostMapping("/store")
    public ResponseEntity<?> createStore(@RequestBody CreateStoreRequestDto createStoreRequestDto) {
        try {
            return ResponseEntity.status(HttpStatus.CREATED).body(storeService.createStore(createStoreRequestDto));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/store")
    public ResponseEntity<?> getStore() {
        try {
            String username = SecurityUtil.getCurrentUser();
            return ResponseEntity.ok(storeService.getStore(username));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/store/open")
    public ResponseEntity<?> openStore() {
        try {
            storeService.changeOpenStatus(SecurityUtil.getCurrentUser());
            return ResponseEntity.ok("Successfully changed open status");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/store/keyword/{keyword}")
    public ResponseEntity<?> getStoreByKeyword(@PathVariable("keyword") String keyword) {
        try {
            return ResponseEntity.ok(storeService.getStoreByKeyword(keyword));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/store/category/{categoryId}")
    public ResponseEntity<?> getStoreByCategory(@PathVariable("categoryId") Long categoryId) {
        try {
            return ResponseEntity.ok(storeService.getStoreByCategory(categoryId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PatchMapping("/store/{storeId}")
    public ResponseEntity<?> updateStore(@PathVariable("storeId") Long storeId, @RequestBody UpdateStoreRequestDto updateStoreRequestDto) {
        try {
            storeService.updateStore(storeId, updateStoreRequestDto);
            return ResponseEntity.ok("Successfully updated store");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}
