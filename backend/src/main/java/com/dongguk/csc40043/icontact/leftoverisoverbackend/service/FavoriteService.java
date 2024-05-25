package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.common.SecurityUtil;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Member;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.favorite.FavoriteRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto.GetStoreResponseDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.FavoriteRepository;
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
public class FavoriteService {

    private final FavoriteRepository favoriteRepository;
    private final MemberRepository memberRepository;
    private final StoreRepository storeRepository;

    @Transactional
    public void addFavorite(FavoriteRequestDto favoriteRequestDto) {
        Member member = memberRepository.findByUsernameAndDeleted(SecurityUtil.getCurrentUser(), false).orElseThrow(() ->
                new IllegalArgumentException("존재하지 않는 회원입니다."));
        Store store = storeRepository.findByIdAndDeleted(favoriteRequestDto.getStoreId(), false).orElseThrow(() ->
                new IllegalArgumentException("존재하지 않는 식당입니다."));
        favoriteRepository.save(favoriteRequestDto.toEntity(member, store));
    }

    public List<GetStoreResponseDto> getFavoriteList() {
        Member member = memberRepository.findByUsernameAndDeleted(SecurityUtil.getCurrentUser(), false).orElseThrow(() ->
                new IllegalArgumentException("존재하지 않는 회원입니다."));
        List<Store> storeList = favoriteRepository.findStoreIdByMember(member);
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

    @Transactional
    public void deleteFavorite(FavoriteRequestDto favoriteRequestDto) {
        Member member = memberRepository.findByUsernameAndDeleted(SecurityUtil.getCurrentUser(), false).orElseThrow(() ->
                new IllegalArgumentException("존재하지 않는 회원입니다."));
        Store store = storeRepository.findByIdAndDeleted(favoriteRequestDto.getStoreId(), false).orElseThrow(() ->
                new IllegalArgumentException("존재하지 않는 식당입니다."));
        favoriteRepository.deleteByMemberAndStore(member, store);
    }

}