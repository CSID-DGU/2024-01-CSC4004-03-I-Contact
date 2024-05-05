package com.dongguk.csc40043.icontact.leftoverisoverbackend.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Store {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "store_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id")
    private Owner owner;

    private String name;

    private LocalTime startTime;

    private LocalTime endTime;

    private String address;

    private String phone;

    @Column(columnDefinition = "boolean default false")
    private boolean isDeleted;

    @OneToMany(mappedBy = "store", cascade = CascadeType.PERSIST)
    private List<Order> orders = new ArrayList<>();

    @OneToMany(mappedBy = "store", cascade = CascadeType.PERSIST)
    private List<FavoriteStore> favoriteStores = new ArrayList<>();

    @OneToMany(mappedBy = "store", cascade = CascadeType.PERSIST)
    private List<Food> foods = new ArrayList<>();

    @Builder
    public Store(Long id, Owner owner, String name, LocalTime startTime, LocalTime endTime, String address, String phone, boolean isDeleted, List<Order> orders, List<FavoriteStore> favoriteStores, List<Food> foods) {
        this.id = id;
        this.owner = owner;
        this.name = name;
        this.startTime = startTime;
        this.endTime = endTime;
        this.address = address;
        this.phone = phone;
        this.isDeleted = isDeleted;
        this.orders = orders;
        this.favoriteStores = favoriteStores;
        this.foods = foods;
    }

}
