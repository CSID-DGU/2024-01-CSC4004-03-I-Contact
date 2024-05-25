package com.dongguk.csc40043.icontact.leftoverisoverbackend.controller;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.favorite.FavoriteRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.service.FavoriteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class FavoriteController {

    private final FavoriteService favoriteService;

    @PostMapping("/favorite")
    public ResponseEntity<?> addFavorite(@RequestBody FavoriteRequestDto favoriteRequestDto) {
        try {
            favoriteService.addFavorite(favoriteRequestDto);
            return ResponseEntity.ok("Successfully added favorite store");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/favorite")
    public ResponseEntity<?> getFavoriteList() {
        try {
            return ResponseEntity.ok(favoriteService.getFavoriteList());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/favorite")
    public ResponseEntity<?> deleteFavorite(@RequestBody FavoriteRequestDto favoriteRequestDto) {
        try {
            favoriteService.deleteFavorite(favoriteRequestDto);
            return ResponseEntity.ok("Successfully deleted favorite store");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}
