package com.dongguk.csc40043.icontact.leftoverisoverbackend.domain;

import jakarta.persistence.*;
import lombok.Getter;

@Entity
@Table(name = "favorite_store")
@Getter
public class FavoriteStore {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "favorite_store_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id")
    private Customer customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id")
    private Store store;

}
