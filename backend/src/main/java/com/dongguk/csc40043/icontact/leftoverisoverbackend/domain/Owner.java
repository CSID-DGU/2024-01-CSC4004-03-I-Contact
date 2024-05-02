package com.dongguk.csc40043.icontact.leftoverisoverbackend.domain;

import jakarta.persistence.*;
import lombok.Getter;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
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

}
