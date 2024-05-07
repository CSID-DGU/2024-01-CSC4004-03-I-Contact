package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.common.JwtTokenProvider;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Owner;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.owner.CreateOwnerRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.owner.LoginRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.CreateOwnerResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.LoginResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.OwnerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class OwnerService {

    private final OwnerRepository ownerRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final JwtTokenProvider jwtTokenProvider;

    @Transactional
    public CreateOwnerResponseDto createOwner(CreateOwnerRequestDto createOwnerRequestDto) {
        if (ownerRepository.existsByUsername(createOwnerRequestDto.getUsername())) {
            throw new IllegalStateException("이미 존재하는 점주");
        }
        Owner owner = Owner.builder()
                .username(createOwnerRequestDto.getUsername())
                .name(createOwnerRequestDto.getName())
                .email(createOwnerRequestDto.getEmail())
                .password(passwordEncoder.encode(createOwnerRequestDto.getPassword()))
                .isDeleted(false)
                .build();
        ownerRepository.save(owner);
        return new CreateOwnerResponseDto(owner.getId());
    }

    @Transactional
    public LoginResponseDto login(LoginRequestDto loginRequestDto) {
        String username = loginRequestDto.getUsername();
        String password = loginRequestDto.getPassword();
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(username, password);
        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);
        return jwtTokenProvider.generateToken(authentication);
    }

    @Transactional
    public Long addStore(Long ownerId, Long storeId) {
        Owner owner = ownerRepository.findById(ownerId).orElseThrow(() -> new EntityNotFoundException(ownerId + ": 해당 아이디의 점주 없음"));
        Store store = storeRepository.findById(storeId).orElseThrow(() -> new EntityNotFoundException(storeId + ": 해당 아이디의 매장 없음"));
        owner.getStores().add(store);
        ownerRepository.save(owner);
        return ownerId;
    }

    @Transactional
    public void deleteOwner(Long id) {
        ownerRepository.deleteById(id);
    }

}
