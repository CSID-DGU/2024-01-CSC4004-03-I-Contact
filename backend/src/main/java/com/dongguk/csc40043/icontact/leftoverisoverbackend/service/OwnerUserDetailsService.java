package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Owner;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.repository.OwnerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OwnerUserDetailsService implements UserDetailsService {

    private final OwnerRepository ownerRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Owner owner = ownerRepository.findByUsername(username);
        if (owner == null) {
            throw new UsernameNotFoundException("해당하는 회원을 찾을 수 없습니다.");
        }
        return owner;
    }

}
