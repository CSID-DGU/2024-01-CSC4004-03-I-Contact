package com.dongguk.csc40043.icontact.leftoverisoverbackend.domain;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Food {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "food_id")
    private Long id;

    String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id")
    private Store store;

    @Column(columnDefinition = "int default 0")
    private int firstPrice;

    @Column(columnDefinition = "int default 0")
    private int sellPrice;

    @Builder.Default
    @Column(columnDefinition = "int default 0")
    private int capacity = 0;

    @Builder.Default
    @Column(columnDefinition = "int default 0")
    private int visits = 0;

    @Builder.Default
    @Column(columnDefinition = "boolean default false")
    private boolean isVisible = false;

    @Builder.Default
    @Column(columnDefinition = "boolean default false")
    private boolean deleted = false;

    @Builder.Default
    @OneToMany(mappedBy = "food", cascade = CascadeType.PERSIST)
    private List<OrderFood> orderFoods = new ArrayList<>();

}
