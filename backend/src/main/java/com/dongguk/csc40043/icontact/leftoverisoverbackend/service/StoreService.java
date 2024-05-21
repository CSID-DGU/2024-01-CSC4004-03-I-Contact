package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Category;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Member;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.store.CreateStoreRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.CreateStoreResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.GetStoreResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.StoreDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.CategoryRepository;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.MemberRepository;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.StoreRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;


@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class StoreService {

    private final StoreRepository storeRepository;
    private final MemberRepository memberRepository;
    private final CategoryRepository categoryRepository;

    @Transactional
    public CreateStoreResponseDto createStore(CreateStoreRequestDto createStoreRequestDto) {
        Member member = memberRepository.findByUsernameAndDeleted(createStoreRequestDto.getUsername(), false);
        Category category = categoryRepository.findById(createStoreRequestDto.getCategoryId()).orElse(null);
        StoreDto storeDto = createStoreRequestDto.toServiceDto(member, category);
        Store store = storeRepository.save(storeDto.toEntity(member, category));
        return new CreateStoreResponseDto(store.getId());
    }

    public GetStoreResponseDto getStore(String username) {
        Member member = memberRepository.findByUsernameAndDeleted(username, false);
        Store store = storeRepository.findByMemberAndDeleted(member, false);
        return GetStoreResponseDto.builder()
                .storeId(store.getId())
                .ownerId(store.getMember().getId())
                .categoryId(store.getCategory().getId())
                .name(store.getName())
                .startTime(store.getStartTime().toString())
                .endTime(store.getEndTime().toString())
                .address(store.getAddress())
                .phone(store.getPhone())
                .isOpen(store.isOpen())
                .deleted(store.isDeleted())
                .build();
    }

    @Transactional
    public void changeOpenStatus(String username) {
        Member member = memberRepository.findByUsernameAndDeleted(username, false);
        Store store = storeRepository.findByMemberAndDeleted(member, false);
        store.toggleIsOpen();
        storeRepository.save(store);
    }

    public List<GetStoreResponseDto> getStoreByKeyword(String keyword) {
        List<Store> storeList = storeRepository.findByNameContaining(keyword);
        return storeList.stream()
                .map(store -> GetStoreResponseDto.builder()
                        .storeId(store.getId())
                        .ownerId(store.getMember().getId())
                        .categoryId(store.getCategory().getId())
                        .name(store.getName())
                        .startTime(store.getStartTime().toString())
                        .endTime(store.getEndTime().toString())
                        .address(store.getAddress())
                        .phone(store.getPhone())
                        .isOpen(store.isOpen())
                        .deleted(store.isDeleted())
                        .build()
                )
                .collect(Collectors.toList());
    }

}
