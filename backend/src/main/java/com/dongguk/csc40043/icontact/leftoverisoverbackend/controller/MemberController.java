package com.dongguk.csc40043.icontact.leftoverisoverbackend.controller;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.common.SecurityUtil;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.member.*;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@Tag(name = "Member", description = "회원 API")
public class MemberController {

    private final MemberService memberService;
    private final PasswordEncoder passwordEncoder;

    @PostMapping("/member")
    @Operation(summary = "회원 가입", description = "회원을 가입합니다.")
    public ResponseEntity<?> createMember(@RequestBody CreateMemberRequestDto createMemberRequestDto) {
        try {
            memberService.createMember(createMemberRequestDto.toServiceDto(passwordEncoder.encode(createMemberRequestDto.getPassword()), createMemberRequestDto.getRoles()));
            return ResponseEntity.status(HttpStatus.CREATED).body("Successfully created member");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/login")
    @Operation(summary = "로그인", description = "로그인합니다.")
    public ResponseEntity<?> login(@RequestBody LoginRequestDto loginRequestDto) {
        try {
            return ResponseEntity.status(HttpStatus.OK).body(memberService.login(loginRequestDto));
        } catch (UsernameNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/save-fcm-token")
    @Operation(summary = "FCM 토큰 저장", description = "FCM 토큰을 저장합니다.")
    public ResponseEntity<?> updateFcmToken(@RequestBody FcmTokenDto fcmTokenDto) {
        try {
            memberService.updateFcmToken(fcmTokenDto);
            return ResponseEntity.status(HttpStatus.OK).body("Successfully updated fcm token");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }

    }

    @PostMapping("/duplicate-username")
    @Operation(summary = "중복 유저네임 체크", description = "유저네임이 중복되는지 체크합니다.")
    public ResponseEntity<?> checkDuplicateUsername(@RequestBody CheckDuplicateRequestDto checkDuplicateRequestDto) {
        try {
            memberService.checkDuplicate(checkDuplicateRequestDto);
            return ResponseEntity.status(HttpStatus.OK).body("Available username");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/member")
    @Operation(summary = "회원 삭제", description = "회원을 삭제합니다.")
    public ResponseEntity<?> deleteMember() {
        try {
            String username = SecurityUtil.getCurrentUser();
            memberService.deleteMember(username);
            return ResponseEntity.status(HttpStatus.OK).body("Member deleted successfully");
        } catch (UsernameNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PatchMapping("/member")
    @Operation(summary = "회원 수정", description = "회원을 수정합니다.")
    public ResponseEntity<?> updateMember(@RequestBody UpdateMemberRequestDto updateMemberRequestDto) {
        try {
            memberService.updateMember(updateMemberRequestDto);
            return ResponseEntity.ok("Successfully updated member");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/member")
    @Operation(summary = "회원 조회", description = "회원을 조회합니다.")
    public ResponseEntity<?> getMember() {
        try {
            return ResponseEntity.ok(memberService.getMember(SecurityUtil.getCurrentUser()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }

    }

}