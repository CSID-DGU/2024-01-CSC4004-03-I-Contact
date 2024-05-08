package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Owner;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.owner.CreateOwnerRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.owner.LoginRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.CreateOwnerResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.LoginResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.OwnerRepository;
import jakarta.transaction.Transactional;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import static org.junit.Assert.*;

@RunWith(SpringRunner.class)
@SpringBootTest
@Transactional
public class OwnerServiceTest {

    @Autowired
    OwnerService ownerService;
    @Autowired
    OwnerRepository ownerRepository;

    @Test
    public void createOwner() {
        CreateOwnerRequestDto createOwnerRequestDto = new CreateOwnerRequestDto();
        createOwnerRequestDto.setUsername("floreo1242");
        createOwnerRequestDto.setName("Jinsoo Yoon");
        createOwnerRequestDto.setEmail("floreo1242@gmail.com");
        createOwnerRequestDto.setPassword("testpasswd");

        CreateOwnerResponseDto createOwnerResponseDto = ownerService.createOwner(createOwnerRequestDto);
        Owner savedOwner = ownerRepository.findById(createOwnerResponseDto.getId()).orElse(null);

        assert savedOwner != null;
        assertEquals(createOwnerResponseDto.getId(), savedOwner.getId());
    }

    @Test
    public void login() {
        createOwner();
        LoginRequestDto loginRequestDto = new LoginRequestDto();
        loginRequestDto.setUsername("floreo1242");
        loginRequestDto.setPassword("testpasswd");
        LoginResponseDto authenticated = ownerService.login(loginRequestDto);
        assertNotNull(authenticated);
    }

    @Test
    public void deleteOwner() {
        CreateOwnerRequestDto createOwnerRequestDto = new CreateOwnerRequestDto();
        createOwnerRequestDto.setUsername("floreo1242");
        createOwnerRequestDto.setName("Jinsoo Yoon");
        createOwnerRequestDto.setEmail("floreo1242@gmail.com");
        createOwnerRequestDto.setPassword("testpasswd");
        CreateOwnerResponseDto createOwnerResponseDto = ownerService.createOwner(createOwnerRequestDto);

        ownerService.deleteOwner(createOwnerResponseDto.getId());

        Owner owner = ownerRepository.findById(createOwnerResponseDto.getId()).orElse(null);
        assertNull(owner);
    }

}