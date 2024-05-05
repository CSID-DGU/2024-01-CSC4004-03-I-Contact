package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Owner;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.OwnerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class OwnerService {

    private final OwnerRepository ownerRepository;

    @Transactional
    public Long createOwner(Owner owner) {
        validateDuplicateOwner(owner);
        ownerRepository.save(owner);
        return owner.getId();
    }

    private void validateDuplicateOwner(Owner owner) {
        if (ownerRepository.existsByUsername(owner.getUsername())) {
            throw new IllegalStateException("이미 존재하는 회원입니다.");
        }
    }

    public boolean authenticate(String username, String password) {
        Owner owner = ownerRepository.findByUsername(username);
        if (owner != null) {
            return owner.getPassword().equals(password);
        }
        return false;
    }

    public void deleteOwner(Long id) {
        ownerRepository.deleteById(id);
    }

}
