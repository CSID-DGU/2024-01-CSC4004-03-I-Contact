package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.common.JwtTokenProvider;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.common.SecurityUtil;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Member;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.MemberDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.member.*;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.FindUsernameResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.GetMemberResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.LoginResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.MemberRepository;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.StoreRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;
    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final UserDetailsService userDetailsService;
    private final JwtTokenProvider jwtTokenProvider;
    private final PasswordEncoder passwordEncoder;
    private final StoreRepository storeRepository;

    @Transactional
    public void createMember(MemberDto memberDto) {
        isDuplicated(memberDto.getUsername());
        memberRepository.save(memberDto.toEntity());
    }

    @Transactional
    public LoginResponseDto login(LoginRequestDto loginRequestDto) {
        String requestedRole = loginRequestDto.getRoles().get(0);
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(
                loginRequestDto.getUsername(),
                loginRequestDto.getPassword()
        );
        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);
        SecurityContextHolder.getContext().setAuthentication(authentication);
        UserDetails userDetails = userDetailsService.loadUserByUsername(loginRequestDto.getUsername());
        boolean hasRole = userDetails.getAuthorities().stream().anyMatch(authority -> authority.getAuthority().equals(requestedRole));
        if (!hasRole) {
            throw new UsernameNotFoundException("해당하는 회원을 찾을 수 없습니다.");
        }
        return jwtTokenProvider.generateToken(authentication);
    }

    @Transactional
    public void updateFcmToken(FcmTokenDto fcmTokenDto) {
        Member member = memberRepository.findByUsernameAndDeleted(SecurityUtil.getCurrentUser(), false).orElseThrow(() ->
                new UsernameNotFoundException("존재하지 않는 회원입니다."));
        member.updateFcmToken(fcmTokenDto.getFcmToken());
    }

    public void checkDuplicate(CheckDuplicateRequestDto checkDuplicateRequestDto) {
        isDuplicated(checkDuplicateRequestDto.getUsername());
    }

    @Transactional
    public void deleteMember(String username) {
        Member member = memberRepository.findByUsernameAndDeleted(username, false).orElseThrow(() ->
                new UsernameNotFoundException("존재하지 않는 회원입니다."));
        Store store = storeRepository.findByMemberAndDeleted(member, false).orElseThrow(() ->
                new IllegalArgumentException("존재하지 않는 식당입니다."));
        storeRepository.delete(store);
        memberRepository.delete(member);
    }

    private void isDuplicated(String username) {
        if (memberRepository.existsByUsernameAndDeleted(username, false)) {
            throw new IllegalStateException("이미 존재하는 회원입니다.");
        }
    }

    @Transactional
    public void updateMember(UpdateMemberRequestDto updateMemberRequestDto) {
        Member member = memberRepository.findByUsernameAndDeleted(SecurityUtil.getCurrentUser(), false).orElseThrow(() ->
                new UsernameNotFoundException("존재하지 않는 회원입니다."));
        if (updateMemberRequestDto.getUsername() != null)
            member.updateUsername(updateMemberRequestDto.getUsername());
        if (updateMemberRequestDto.getName() != null)
            member.updateName(updateMemberRequestDto.getName());
        if (updateMemberRequestDto.getEmail() != null)
            member.updateEmail(updateMemberRequestDto.getEmail());
        if (updateMemberRequestDto.getPhone() != null)
            member.updatePhone(updateMemberRequestDto.getPhone());
        if (updateMemberRequestDto.getPassword() != null)
            member.updatePassword(passwordEncoder.encode(updateMemberRequestDto.getPassword()));
    }

    public GetMemberResponseDto getMember(String username) {
        Member member = memberRepository.findByUsernameAndDeleted(username, false).orElseThrow(() ->
                new UsernameNotFoundException("존재하지 않는 회원입니다."));
        return GetMemberResponseDto.builder()
                .username(member.getUsername())
                .name(member.getName())
                .email(member.getEmail())
                .phone(member.getPhone())
                .build();
    }

    public FindUsernameResponseDto findUsername(FindUsernameRequestDto findUsernameRequestDto) {
        Member member = memberRepository.findByEmailAndPhoneAndDeleted(findUsernameRequestDto.getEmail(), findUsernameRequestDto.getPhone(), false).orElseThrow(() ->
                new UsernameNotFoundException("존재하지 않는 회원입니다."));
        if (!member.getName().equals(findUsernameRequestDto.getName()) || !member.getEmail().equals(findUsernameRequestDto.getEmail()) || !member.getPhone().equals(findUsernameRequestDto.getPhone())) {
            throw new IllegalArgumentException("입력한 정보가 일치하지 않습니다.");
        }
        return FindUsernameResponseDto.builder()
                .memberId(member.getId())
                .role(member.getRoles().get(0))
                .username(member.getUsername())
                .build();
    }

    @Transactional
    public void resetPassword(ResetPasswordRequestDto resetPasswordRequestDto) {
        Member member = memberRepository.findByUsernameAndDeleted(resetPasswordRequestDto.getUsername(), false).orElseThrow(() ->
                new UsernameNotFoundException("존재하지 않는 회원입니다."));
        if (!member.getName().equals(resetPasswordRequestDto.getName()) || !member.getEmail().equals(resetPasswordRequestDto.getEmail()) || !member.getPhone().equals(resetPasswordRequestDto.getPhone())) {
            throw new IllegalArgumentException("입력한 정보가 일치하지 않습니다.");
        }
        member.updatePassword(passwordEncoder.encode(resetPasswordRequestDto.getNewPassword()));
    }

}