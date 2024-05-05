package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Owner;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.OwnerDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.StoreDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.OwnerRepository;
import jakarta.transaction.Transactional;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
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
        OwnerDto ownerDto = new OwnerDto();
        ownerDto.setUsername("floreo1242");
        ownerDto.setName("Jinsoo Yoon");
        ownerDto.setEmail("floreo1242@gmail.com");
        ownerDto.setPassword("testpasswd");

        Long savedId = ownerService.createOwner(ownerDto.toEntity());
        Owner savedOwner = ownerRepository.findById(savedId).orElse(null);

        assert savedOwner != null;
        assertEquals(savedId, savedOwner.getId());
    }

    @Test
    public void authenticate() {
        createOwner();
        boolean authenticated = ownerService.authenticate("floreo1242", "testpasswd");
        assertTrue(authenticated);
    }

    @Test
    public void addStore() {
        OwnerDto ownerDto = new OwnerDto();
        ownerDto.setUsername("floreo1242");
        ownerDto.setName("Jinsoo Yoon");
        ownerDto.setEmail("floreo1242@gmail.com");
        ownerDto.setPassword("testpasswd");
        Long ownerId = ownerService.createOwner(ownerDto.toEntity());
        StoreDto storeDto = new StoreDto();
        storeDto.setOwner(ownerDto.toEntity());
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
        OwnerDto ownerDto = new OwnerDto();
        ownerDto.setUsername("floreo1242");
        ownerDto.setName("Jinsoo Yoon");
        ownerDto.setEmail("floreo1242@gmail.com");
        ownerDto.setPassword("testpasswd");

        Long savedId = ownerService.createOwner(ownerDto.toEntity());
        ownerService.deleteOwner(savedId);
        Owner owner = ownerRepository.findById(savedId).orElse(null);
        assertNull(owner);
    }

}