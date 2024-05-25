package com.dongguk.csc40043.icontact.leftoverisoverbackend.controller;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.favorite.AddFavoriteRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.service.FavoriteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class FavoriteController {

    private final FavoriteService favoriteService;

    @PostMapping("/favorite")
    public ResponseEntity<?> addFavorite(@RequestBody AddFavoriteRequestDto addFavoriteRequestDto) {
        try {
            favoriteService.addFavorite(addFavoriteRequestDto);
            return ResponseEntity.ok("Successfully added favorite store");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}
