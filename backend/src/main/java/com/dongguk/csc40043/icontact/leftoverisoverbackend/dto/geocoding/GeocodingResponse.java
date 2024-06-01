package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.geocoding;

import lombok.Data;

import java.util.List;

@Data
public class GeocodingResponse {

    private String status;

    private Meta meta;

    private List<Address> addresses;

    private String errorMessage;

}
