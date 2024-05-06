package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Owner;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.CreateOwnerRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.CreateStoreRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.LoginRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.LoginResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.OwnerRepository;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.StoreRepository;
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
    @Autowired
    private StoreService storeService;
    @Autowired
    private StoreRepository storeRepository;


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
        CreateStoreRequestDto createStoreRequestDto = new CreateStoreRequestDto();
        createStoreRequestDto.setOwnerId(ownerId);
        createStoreRequestDto.setName("Burger King");
        createStoreRequestDto.setStartTime("09:00:00");
        createStoreRequestDto.setEndTime("18:00:00");
        createStoreRequestDto.setAddress("Address");
        createStoreRequestDto.setPhone("02-1234-5678");
        Long storeId = storeService.createStore(createStoreRequestDto);
        ownerService.addStore(ownerId, storeId);
        Owner savedOwner = ownerRepository.findById(ownerId).orElse(null);
        Store store = storeRepository.findById(storeId).orElse(null);
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