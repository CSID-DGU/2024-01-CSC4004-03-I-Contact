package com.dongguk.csc40043.icontact.leftoverisoverbackend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Category;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {

}
