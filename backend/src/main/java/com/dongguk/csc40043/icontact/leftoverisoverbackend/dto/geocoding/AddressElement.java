package com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.geocoding;

import lombok.Data;

import java.util.List;

@Data
public class AddressElement {

    private List<String> types;

    private String longName;

    private String shortName;

    private String code;

}
