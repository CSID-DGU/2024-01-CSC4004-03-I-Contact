package com.dongguk.csc40043.icontact.leftoverisoverbackend.domain;

import jakarta.persistence.*;
import lombok.Getter;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
public class Food {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "food_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id")
    private Store store;

    @Column(columnDefinition = "int default 0")
    private int firstPrice;

    @Column(columnDefinition = "int default 0")
    private int sellPrice;

    @Column(columnDefinition = "int default 0")
    private int capacity;

    @Column(columnDefinition = "int default 0")
    private int visits;

    @Column(columnDefinition = "boolean default false")
    private boolean isVisible;

    @Column(columnDefinition = "boolean default false")
    private boolean deleted;

    @OneToMany(mappedBy = "food", cascade = CascadeType.PERSIST)
    private List<OrderFood> orderFoods = new ArrayList<>();

}
