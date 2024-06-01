package com.dongguk.csc40043.icontact.leftoverisoverbackend.service;

import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.geocoding.Address;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.geocoding.CoordinateDto;
import com.dongguk.csc40043.icontact.leftoverisoverbackend.dto.geocoding.GeocodingResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;


@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class GeocodingService {

    private final WebClient webClient;

    public Mono<GeocodingResponse> getCoordinate(String address) {
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/map-geocode/v2/geocode")
                        .queryParam("query", address)
                        .build())
                .retrieve()
                .bodyToMono(GeocodingResponse.class);
    }

    public Mono<CoordinateDto> getCoordinates(String address) {
        return getCoordinate(address)
                .handle((response, sink) -> {
                    if (response.getAddresses() != null && !response.getAddresses().isEmpty()) {
                        Address addressDto = response.getAddresses().get(0);
                        sink.next(new CoordinateDto(Double.parseDouble(addressDto.getY()), Double.parseDouble(addressDto.getX())));
                    } else {
                        sink.error(new RuntimeException("No coordinates found for the address"));
                    }
                });
    }

}
