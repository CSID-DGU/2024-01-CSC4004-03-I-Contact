package com.dongguk.csc40043.icontact.leftoverisoverbackend.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Owner {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "owner_id")
    private Long id;

    private String username;

    private String name;

    private String password;

    private String email;

    @Column(columnDefinition = "boolean default false")
    private boolean isDeleted;

    @OneToMany(mappedBy = "owner", cascade = CascadeType.PERSIST)
    private List<Store> stores = new ArrayList<>();

    @Builder
    public Owner(Long id, String username, String name, String password, String email, boolean isDeleted, List<Store> stores) {
        this.id = id;
        this.username = username;
        this.name = name;
        this.password = password;
        this.email = email;
        this.isDeleted = isDeleted;
        this.stores = stores;
    }

}
