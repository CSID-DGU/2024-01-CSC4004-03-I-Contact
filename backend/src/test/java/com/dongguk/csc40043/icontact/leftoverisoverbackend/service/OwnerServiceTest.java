package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Owner;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.OwnerDto;
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