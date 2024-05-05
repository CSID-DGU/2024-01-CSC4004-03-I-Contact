package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Owner;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.OwnerRepository;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.StoreRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class OwnerService {

    private final OwnerRepository ownerRepository;
    private final StoreRepository storeRepository;

    @Transactional
    public Long createOwner(Owner owner) {
        validateDuplicateOwner(owner);
        ownerRepository.save(owner);
        return owner.getId();
    }

    private void validateDuplicateOwner(Owner owner) {
        if (ownerRepository.existsByUsername(owner.getUsername())) {
            throw new IllegalStateException("이미 존재하는 점주");
        }
    }

    public boolean authenticate(String username, String password) {
        Owner owner = ownerRepository.findByUsername(username);
        if (owner != null) {
            return owner.getPassword().equals(password);
        }
        return false;
    }

    @Transactional
    public Long addStore(Long ownerId, Long storeId) {
        Owner owner = ownerRepository.findById(ownerId)
                .orElseThrow(() -> new EntityNotFoundException(ownerId + ": 해당 아이디의 점주 없음"));
        Store store = storeRepository.findById(storeId)
                .orElseThrow(() -> new EntityNotFoundException(storeId + ": 해당 아이디의 매장 없음"));
        owner.getStores().add(store);
        ownerRepository.save(owner);
        return ownerId;
    }

    @Transactional
    public void deleteOwner(Long id) {
        ownerRepository.deleteById(id);
    }

}
