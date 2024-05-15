package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.common.JwtTokenProvider;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Member;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.MemberDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.member.CheckDuplicateRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.member.LoginRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.LoginResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;
    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final JwtTokenProvider jwtTokenProvider;

    @Transactional
    public void createMember(MemberDto memberDto) {
        isDuplicated(memberDto.getUsername());
        memberRepository.save(memberDto.toEntity());
    }

    @Transactional
    public LoginResponseDto login(LoginRequestDto loginRequestDto) {
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(
                loginRequestDto.getUsername(),
                loginRequestDto.getPassword()
        );
        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);
        return jwtTokenProvider.generateToken(authentication);
    }

    public void checkDuplicate(CheckDuplicateRequestDto checkDuplicateRequestDto) {
        isDuplicated(checkDuplicateRequestDto.getUsername());
    }

    @Transactional
    public void deleteMember(String username) {
        Member member = memberRepository.findByUsernameAndDeleted(username, false);
        if (member == null) {
            throw new UsernameNotFoundException("해당하는 회원을 찾을 수 없습니다.");
        }
        memberRepository.delete(member);
    }

    void isDuplicated(String username) {
        if (memberRepository.existsByUsernameAndDeleted(username, false)) {
            throw new IllegalStateException("이미 존재하는 회원입니다.");
        }
    }

}
