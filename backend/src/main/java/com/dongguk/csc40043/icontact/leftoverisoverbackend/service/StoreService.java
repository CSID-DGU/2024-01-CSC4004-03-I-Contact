package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Owner;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.store.CreateStoreRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.CreateStoreResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.OwnerRepository;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.StoreRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalTime;
import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class StoreService {

    private final StoreRepository storeRepository;
    private final OwnerRepository ownerRepository;

    @Transactional
    public CreateStoreResponseDto createStore(CreateStoreRequestDto createStoreRequestDto) {
        Owner owner = ownerRepository.findById(createStoreRequestDto.getOwnerId()).orElseThrow(() -> new RuntimeException("Owner not found"));
        Store store = Store.builder()
                .owner(owner)
                .name(createStoreRequestDto.getName())
                .startTime(LocalTime.parse(createStoreRequestDto.getStartTime()))
                .endTime(LocalTime.parse(createStoreRequestDto.getEndTime()))
                .address(createStoreRequestDto.getAddress())
                .phone(createStoreRequestDto.getPhone())
                .isDeleted(false)
                .build();
        storeRepository.save(store);
        return new CreateStoreResponseDto(store.getId());
    }

    public List<Store> getStoreList(Owner owner) {
        return storeRepository.findAllByOwner(owner);
    }

    public Store getStore(Long storeId) {
        return storeRepository.findById(storeId).orElse(null);
    }


    @Transactional
    public void deleteStore(Long storeId) {
        storeRepository.deleteById(storeId);
    }
}
