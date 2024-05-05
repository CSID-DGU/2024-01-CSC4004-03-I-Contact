package com.dongguk.csc40043.icontact.leftoverisoverbackend.controller;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.CreateOwnerRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.LoginRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.CreateOwnerResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.service.OwnerService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class OwnerController {

    private final OwnerService ownerService;

    @PostMapping("api/v1/owner/create")
    public ResponseEntity<?> createOwner(@RequestBody CreateOwnerRequestDto createOwnerRequestDto) {
        try {
            Long id = ownerService.createOwner(createOwnerRequestDto);
            return ResponseEntity.status(HttpStatus.CREATED).body(new CreateOwnerResponseDto(id));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("api/v1/owner/login")
    public ResponseEntity<?> login(@RequestBody LoginRequestDto loginRequestDto) {
        try {
            return ResponseEntity.status(HttpStatus.OK).body(ownerService.login(loginRequestDto));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}
