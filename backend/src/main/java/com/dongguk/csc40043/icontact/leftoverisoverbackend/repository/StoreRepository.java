package com.dongguk.csc40043.icontact.leftoverisoverbackend.repository;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Member;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.domain.Store;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StoreRepository extends JpaRepository<Store, Long> {

    Optional<Store> findByMemberAndDeleted(Member member, boolean deleted);

    List<Store> findByNameContaining(String name);

    @Query(value = "SELECT *, ST_Distance_Sphere(point(longitude, latitude), point(:targetLon, :targetLat)) as distance FROM store ORDER BY distance", nativeQuery = true)
    List<Store> findAllSortedByDistance(double targetLat, double targetLon);

    @Query(value = "SELECT *, ST_Distance_Sphere(point(longitude, latitude), point(:targetLon, :targetLat)) as distance FROM store WHERE category_id = :categoryId ORDER BY distance", nativeQuery = true)
    List<Store> findByCategoryIdSortedByDistance(Long categoryId, double targetLat, double targetLon);

    Optional<Store> findByIdAndDeleted(Long id, boolean deleted);

}
