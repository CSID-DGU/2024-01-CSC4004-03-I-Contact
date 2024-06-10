package com.dongguk.csc40043.icontact.leftoverisoverbackend.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Store {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "store_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id")
    private Member member;

    private Long categoryId;

    private String name;

    private LocalTime startTime;

    private LocalTime endTime;

    private String address;

    private String phone;

    private Double latitude;

    private Double longitude;

    @Column(columnDefinition = "boolean default false")
    private boolean isOpen;

    @Column(columnDefinition = "boolean default false")
    private boolean deleted;

    @Builder.Default
    @OneToMany(mappedBy = "store", cascade = CascadeType.PERSIST)
    private List<Order> orders = new ArrayList<>();

    @Builder.Default
    @OneToMany(mappedBy = "store", cascade = CascadeType.PERSIST)
    private List<FavoriteStore> favoriteStores = new ArrayList<>();

    @Builder.Default
    @OneToMany(mappedBy = "store", cascade = CascadeType.PERSIST)
    private List<Food> foods = new ArrayList<>();

    public boolean toggleIsOpen() {
        this.isOpen = !this.isOpen;
        return this.isOpen;
    }

    public void updateName(String name) {
        this.name = name;
    }

    public void updateStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public void updateEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public void updateAddress(String address) {
        this.address = address;
    }

    public void updatePhone(String phone) {
        this.phone = phone;
    }

    public void updateCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

}
