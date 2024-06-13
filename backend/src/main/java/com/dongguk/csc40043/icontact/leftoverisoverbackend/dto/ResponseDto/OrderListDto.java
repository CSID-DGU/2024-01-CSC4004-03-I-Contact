package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.ResponseDto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class OrderListDto {

    private Customer customer;

    private OrderStore store;

    private String orderDate;

    private String status;

    private Long orderNum;

    private Boolean appPay;

    private List<Food> orderFood;

    @Data
    @Builder
    public static class Customer {

        private String username;

        private String phone;

        private String email;

    }

    @Data
    @Builder
    public static class OrderStore {

        private Long storeId;

        private String name;
    }

    @Data
    @Builder
    public static class Food {

        private String name;

        private Integer count;

        private String imageUrl;

    }

}
