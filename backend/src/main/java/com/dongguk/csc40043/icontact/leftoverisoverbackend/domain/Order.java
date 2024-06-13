package com.dongguk.csc40043.icontact.leftoverisoverbackend.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "orders")
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "order_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id")
    private Member member;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "store_id")
    private Store store;

    private LocalDateTime orderDate;

    private Boolean appPay;

    @Enumerated(EnumType.STRING)
    private OrderStatus status; // VISIT, ORDER, CANCEL, COMPLETE

    @Builder.Default
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderFood> orderFoods = new ArrayList<>();

    public void addOrderFood(OrderFood orderFood) {
        this.orderFoods.add(orderFood);
        orderFood.addOrder(this);
    }

    public void cancel() {
        this.status = OrderStatus.CANCEL;
    }

    public void complete() {
        this.status = OrderStatus.COMPLETE;
    }
    
}
