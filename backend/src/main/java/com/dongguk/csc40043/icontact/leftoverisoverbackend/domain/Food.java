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
    @OneToMany(mappedBy = "food", cascade = CascadeType.PERSIST)
    private List<OrderFood> orderFoods = new ArrayList<>();

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "image_id")
    private Image image;

    public void updateName(String name) {
        this.name = name;
    }

    public void updateFirstPrice(int firstPrice) {
        this.firstPrice = firstPrice;
    }

    public void updateSellPrice(int sellPrice) {
        this.sellPrice = sellPrice;
    }

    public void updateCapacity(int capacity) {
        this.capacity = capacity;
    }

    public void updateIsVisible(boolean isVisible) {
        this.isVisible = isVisible;
    }

    public void minusCapacity(int count) {
        this.capacity -= count;
    }

    public void updateImage(Image image) {
        this.image = image;
    }

}
