package com.dongguk.csc40043.icontact.leftoverisoverbackend.controller;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.favorite.FavoriteRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.service.FavoriteService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@Tag(name = "Favorite", description = "즐겨찾기 API")
public class FavoriteController {

    private final FavoriteService favoriteService;

    @PostMapping("/favorite")
    @Operation(summary = "즐겨찾기 추가", description = "즐겨찾기를 추가합니다.")
    public ResponseEntity<?> addFavorite(@RequestBody FavoriteRequestDto favoriteRequestDto) {
        try {
            favoriteService.addFavorite(favoriteRequestDto);
            return ResponseEntity.ok("Successfully added favorite store");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/favorite")
    @Operation(summary = "즐겨찾기 조회", description = "즐겨찾기 리스트를 조회합니다.")
    public ResponseEntity<?> getFavoriteList() {
        try {
            return ResponseEntity.ok(favoriteService.getFavoriteList());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/favorite")
    @Operation(summary = "즐겨찾기 삭제", description = "즐겨찾기를 삭제합니다.")
    public ResponseEntity<?> deleteFavorite(@RequestBody FavoriteRequestDto favoriteRequestDto) {
        try {
            favoriteService.deleteFavorite(favoriteRequestDto);
            return ResponseEntity.ok("Successfully deleted favorite store");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}
