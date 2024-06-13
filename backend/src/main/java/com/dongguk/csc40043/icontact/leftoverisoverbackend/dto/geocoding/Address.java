package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.geocoding;

import lombok.Data;

import java.util.List;

@Data
public class Address {

    private String roadAddress;

    private String jibunAddress;

    private String englishAddress;

    private List<AddressElement> addressElements;

    private String x; // Longitude

    private String y; // Latitude

    private double distance;

}
