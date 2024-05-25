package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.common.SecurityUtil;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Member;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.RequestDto.favorite.AddFavoriteRequestDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.FavoriteRepository;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.MemberRepository;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.StoreRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class FavoriteService {

    private final FavoriteRepository favoriteRepository;
    private final MemberRepository memberRepository;
    private final StoreRepository storeRepository;

    @Transactional
    public void addFavorite(AddFavoriteRequestDto addFavoriteRequestDto) {
        Member member = memberRepository.findByUsernameAndDeleted(SecurityUtil.getCurrentUser(), false).orElseThrow(() ->
                new IllegalArgumentException("존재하지 않는 회원입니다."));
        Store store = storeRepository.findByIdAndDeleted(addFavoriteRequestDto.getStoreId(), false).orElseThrow(() ->
                new IllegalArgumentException("존재하지 않는 식당입니다."));
        favoriteRepository.save(addFavoriteRequestDto.toEntity(member, store));
    }

}
