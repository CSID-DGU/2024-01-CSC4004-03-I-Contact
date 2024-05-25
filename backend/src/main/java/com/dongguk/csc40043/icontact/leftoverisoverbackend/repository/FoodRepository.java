package com.dongguk.csc40043.icontact.leftoverisoverbackend.repository;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Food;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository

public interface FoodRepository extends JpaRepository<Food, Long> {

    Optional<Food> findByIdAndDeleted(Long id, boolean deleted);

}
