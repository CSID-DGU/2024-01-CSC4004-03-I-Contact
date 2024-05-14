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

    private String name;

    private LocalTime startTime;

    private LocalTime endTime;

    private String address;

    private String phone;

    @Column(columnDefinition = "boolean default false")
    private boolean isDeleted;

    @Builder.Default
    @OneToMany(mappedBy = "store", cascade = CascadeType.PERSIST)
    private List<Order> orders = new ArrayList<>();

    @Builder.Default
    @OneToMany(mappedBy = "store", cascade = CascadeType.PERSIST)
    private List<FavoriteStore> favoriteStores = new ArrayList<>();

    @Builder.Default
    @OneToMany(mappedBy = "store", cascade = CascadeType.PERSIST)
    private List<Food> foods = new ArrayList<>();

}
