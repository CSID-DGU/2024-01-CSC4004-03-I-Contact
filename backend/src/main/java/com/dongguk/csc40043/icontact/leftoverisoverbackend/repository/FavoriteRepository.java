package com.dongguk.csc40043.icontact.leftoverisoverbackend.repository;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.FavoriteStore;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FavoriteRepository extends JpaRepository<FavoriteStore, Long> {
}
