package com.dongguk.csc40043.icontact.leftoverisoverbackend.controller;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.store.CreateStoreRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.service.StoreService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class StoreController {

    private final StoreService storeService;

    @PostMapping("api/v1/store")
    public ResponseEntity<?> createStore(@RequestBody CreateStoreRequestDto createStoreRequestDto) {
        try {
            return ResponseEntity.status(HttpStatus.CREATED).body(storeService.createStore(createStoreRequestDto));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

//    @DeleteMapping("api/v1/store")
//    public ResponseEntity<?> deleteStore(@RequestBody Delete) {
//
//    }
}
