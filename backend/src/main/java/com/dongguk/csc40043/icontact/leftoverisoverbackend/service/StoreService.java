package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Owner;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.StoreRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class StoreService {

    private final StoreRepository storeRepository;

    @Transactional
    public Long createStore(Store store) {
        storeRepository.save(store);
        return store.getId();
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
