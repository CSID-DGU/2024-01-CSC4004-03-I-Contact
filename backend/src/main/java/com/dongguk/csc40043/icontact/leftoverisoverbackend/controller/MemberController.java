package com.dongguk.csc40043.icontact.leftoverisoverbackend.controller;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.common.SecurityUtil;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.member.CheckDuplicateRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.member.CreateMemberRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.member.LoginRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;
    private final PasswordEncoder passwordEncoder;

    @PostMapping("/member")
    public ResponseEntity<?> createMember(@RequestBody CreateMemberRequestDto createMemberRequestDto) {
        try {
            memberService.createMember(createMemberRequestDto.toServiceDto(passwordEncoder.encode(createMemberRequestDto.getPassword()), createMemberRequestDto.getRoles()));
            return ResponseEntity.status(HttpStatus.CREATED).body("Successfully created member");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequestDto loginRequestDto) {
        try {
            return ResponseEntity.status(HttpStatus.OK).body(memberService.login(loginRequestDto));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PostMapping("/duplicate-username")
    public ResponseEntity<?> checkDuplicateUsername(@RequestBody CheckDuplicateRequestDto checkDuplicateRequestDto) {
        try {
            memberService.checkDuplicate(checkDuplicateRequestDto);
            return ResponseEntity.status(HttpStatus.OK).body("Available username");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @DeleteMapping("/member")
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

}