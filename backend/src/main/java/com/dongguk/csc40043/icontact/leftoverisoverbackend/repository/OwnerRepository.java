package com.dongguk.csc40043.icontact.leftoverisoverbackend.repository;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Owner;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface OwnerRepository extends JpaRepository<Owner, Long> {

    boolean existsByUsername(String username);

    Owner findByUsername(String username);

    Owner findById(long id);

}
