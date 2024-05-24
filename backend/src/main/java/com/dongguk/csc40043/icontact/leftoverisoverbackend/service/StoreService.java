package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Member;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.store.CreateStoreRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.CreateStoreResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.GetStoreResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.StoreDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.MemberRepository;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.StoreRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
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

    @Transactional
    public CreateStoreResponseDto createStore(CreateStoreRequestDto createStoreRequestDto) {
        Member member = memberRepository.findByUsernameAndDeleted(createStoreRequestDto.getUsername(), false).orElseThrow(() ->
                new UsernameNotFoundException("존재하지 않는 회원입니다."));
        StoreDto storeDto = createStoreRequestDto.toServiceDto();
        Store store = storeRepository.save(storeDto.toEntity(member));
        return new CreateStoreResponseDto(store.getId());
    }

    public GetStoreResponseDto getStore(String username) {
        Member member = memberRepository.findByUsernameAndDeleted(username, false).orElseThrow(() ->
                new UsernameNotFoundException("존재하지 않는 회원입니다."));
        Store store = storeRepository.findByMemberAndDeleted(member, false).orElseThrow(() ->
                new IllegalArgumentException("존재하지 않는 식당입니다."));
        return GetStoreResponseDto.builder()
                .storeId(store.getId())
                .ownerId(store.getMember().getId())
                .categoryId(store.getCategoryId())
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
        Member member = memberRepository.findByUsernameAndDeleted(username, false).orElseThrow(() ->
                new UsernameNotFoundException("존재하지 않는 회원입니다."));
        Store store = storeRepository.findByMemberAndDeleted(member, false).orElseThrow(() ->
                new IllegalArgumentException("존재하지 않는 식당입니다."));
        store.toggleIsOpen();
        storeRepository.save(store);
    }

    public List<GetStoreResponseDto> getStoreByKeyword(String keyword) {
        List<Store> storeList = storeRepository.findByNameContaining(keyword);
        return toResponseDto(storeList);
    }

    public List<GetStoreResponseDto> getStoreByCategory(Long categoryId) {
        List<Store> storeList = storeRepository.findByCategoryId(categoryId);
        return toResponseDto(storeList);
    }

    private List<GetStoreResponseDto> toResponseDto(List<Store> storeList) {
        return storeList.stream()
                .map(store -> GetStoreResponseDto.builder()
                        .storeId(store.getId())
                        .ownerId(store.getMember().getId())
                        .categoryId(store.getCategoryId())
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
