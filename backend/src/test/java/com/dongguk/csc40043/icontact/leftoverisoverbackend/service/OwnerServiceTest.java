package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Owner;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.OwnerDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.CreateOwnerRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.LoginRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.LoginResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.StoreDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.OwnerRepository;
import jakarta.transaction.Transactional;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.junit4.SpringRunner;

import java.time.LocalTime;

import static org.junit.Assert.*;

@RunWith(SpringRunner.class)
@SpringBootTest
@Transactional
public class OwnerServiceTest {

    @Autowired
    OwnerService ownerService;
    @Autowired
    OwnerRepository ownerRepository;
    @Autowired
    private StoreService storeService;


    @Test
    public void createOwner() {
        CreateOwnerRequestDto createOwnerRequestDto = new CreateOwnerRequestDto();
        createOwnerRequestDto.setUsername("floreo1242");
        createOwnerRequestDto.setName("Jinsoo Yoon");
        createOwnerRequestDto.setEmail("floreo1242@gmail.com");
        createOwnerRequestDto.setPassword("testpasswd");

        Long savedId = ownerService.createOwner(createOwnerRequestDto);
        Owner savedOwner = ownerRepository.findById(savedId).orElse(null);

        assert savedOwner != null;
        assertEquals(savedId, savedOwner.getId());
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
    public void addStore() {
        CreateOwnerRequestDto createOwnerRequestDto = new CreateOwnerRequestDto();
        createOwnerRequestDto.setUsername("floreo1242");
        createOwnerRequestDto.setName("Jinsoo Yoon");
        createOwnerRequestDto.setEmail("floreo1242@gmail.com");
        createOwnerRequestDto.setPassword("testpasswd");
        Long ownerId = ownerService.createOwner(createOwnerRequestDto);
        StoreDto storeDto = new StoreDto();
        Owner owner = ownerRepository.findById(ownerId).orElse(null);
        storeDto.setOwner(owner);
        storeDto.setName("Burger King");
        storeDto.setStartTime(LocalTime.of(9, 0));
        storeDto.setEndTime(LocalTime.of(21, 0));
        storeDto.setAddress("Address");
        storeDto.setPhone("02-1234-5678");
        Store store = storeDto.toEntity();
        Long storeId = storeService.createStore(store);
        ownerService.addStore(ownerId, storeId);
        Owner savedOwner = ownerRepository.findById(ownerId).orElse(null);
        assertNotNull(savedOwner);
        assertTrue(savedOwner.getStores().contains(store));
    }

    @Test
    public void deleteOwner() {
        CreateOwnerRequestDto createOwnerRequestDto = new CreateOwnerRequestDto();
        createOwnerRequestDto.setUsername("floreo1242");
        createOwnerRequestDto.setName("Jinsoo Yoon");
        createOwnerRequestDto.setEmail("floreo1242@gmail.com");
        createOwnerRequestDto.setPassword("testpasswd");
        Long savedId = ownerService.createOwner(createOwnerRequestDto);

        ownerService.deleteOwner(savedId);
        
        Owner owner = ownerRepository.findById(savedId).orElse(null);
        assertNull(owner);
    }

}