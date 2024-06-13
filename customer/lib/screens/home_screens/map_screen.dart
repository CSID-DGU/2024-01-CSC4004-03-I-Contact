import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/models/store_model.dart';
import 'package:leftover_is_over_customer/services/store_services.dart';
import 'package:leftover_is_over_customer/widgets/resturant_widget.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart'; // Import geocoding package

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double scrollviewHeight = 200.0; // 스크롤 뷰의 초기 높이
  Future<List<StoreModel>>? _futureStore;
  Position? _currentPosition;
  List<NLatLng> _storePositions = [];
  List<String> _storeNames = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndFetchStores();
  }

  Future<void> _getCurrentLocationAndFetchStores() async {
    try {
      _currentPosition = await _getCurrentLocation();
      List<StoreModel> stores =
          await LocationSearchService.getStoreListByLocation(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      await _convertAddressesToCoordinates(stores);
      setState(() {
        _futureStore = Future.value(stores);
      });
    } catch (e) {
      // Handle the error appropriately
      print('Error getting location: $e');
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _convertAddressesToCoordinates(List<StoreModel> stores) async {
    List<NLatLng> positions = [];
    List<String> storeNames = [];
    for (var store in stores) {
      try {
        List<Location> locations = await locationFromAddress(store.address);
        if (locations.isNotEmpty) {
          Location location = locations.first;
          positions.add(NLatLng(location.latitude, location.longitude));
          storeNames.add(store.name);
        }
      } catch (e) {
        print('Error converting address to coordinates: $e');
      }
    }
    setState(() {
      _storePositions = positions;
      _storeNames = storeNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    double minHeight = screenHeight * 0.03;
    double maxHeight = screenHeight * 0.8;

    return Scaffold(
      body: _futureStore == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<StoreModel>>(
              future: _futureStore,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<StoreModel> stores = snapshot.data!;

                  return Stack(
                    children: [
                      NaverMapApp(
                        initialPosition: _currentPosition!,
                        storePositions: _storePositions,
                        storeNames: _storeNames,
                      ),
                      // Draggable scroll view
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            setState(() {
                              // 상단 높이가 최소 높이보다 크고, 하단 높이가 최대 높이보다 작을 때만 조절
                              if (scrollviewHeight - details.primaryDelta! >=
                                      minHeight &&
                                  scrollviewHeight - details.primaryDelta! <=
                                      maxHeight) {
                                scrollviewHeight -= details.primaryDelta!;
                              }
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                color: Colors.grey,
                                height: screenHeight * 0.025, // 드래그 핸들의 높이
                                child: const Center(
                                  child: Icon(
                                    Icons.drag_handle,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                height: scrollviewHeight,
                                color: Colors.white,
                                child: ListView.builder(
                                  itemCount: stores.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final StoreModel store = stores[index];
                                    return RestaurantWidget(
                                        storeId: store.storeId);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
    );
  }
}

class NaverMapApp extends StatefulWidget {
  final Position initialPosition;
  final List<NLatLng> storePositions;
  final List<String> storeNames;

  const NaverMapApp(
      {super.key,
      required this.initialPosition,
      required this.storePositions,
      required this.storeNames});

  @override
  _NaverMapAppState createState() => _NaverMapAppState();
}

class _NaverMapAppState extends State<NaverMapApp> {
  final Completer<NaverMapController> _mapControllerCompleter = Completer();
  late NaverMapController _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addCurrentLocationMarker(widget.initialPosition);
      _addStoreMarkers(widget.storePositions, widget.storeNames);
    });
  }

  void _addCurrentLocationMarker(Position position) {
    if (_mapControllerCompleter.isCompleted) {
      final currentLocationMarker = NMarker(
        id: 'current_location',
        position: NLatLng(
          position.latitude,
          position.longitude,
        ),
      );
      _mapController.addOverlay(currentLocationMarker);

      final onMarkerInfoWindow = NInfoWindow.onMarker(
        id: currentLocationMarker.info.id,
        text: "현재 위치",
      );
      currentLocationMarker.openInfoWindow(onMarkerInfoWindow);
      // 현재 위치로 카메라 이동
      _mapController.updateCamera(
        NCameraUpdate.fromCameraPosition(
          NCameraPosition(
            target: NLatLng(
              position.latitude,
              position.longitude,
            ),
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  void _addStoreMarkers(List<NLatLng> positions, List<String> names) {
    if (_mapControllerCompleter.isCompleted) {
      for (int i = 0; i < positions.length; i++) {
        final storeMarker = NMarker(
          id: names[i],
          position: positions[i],
          iconTintColor: Colors.blue,
        );
        _mapController.addOverlay(storeMarker);

        final onMarkerInfoWindow = NInfoWindow.onMarker(
          id: storeMarker.info.id,
          text: names[i],
        );
        storeMarker.openInfoWindow(onMarkerInfoWindow);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NaverMap(
      onMapReady: (controller) {
        _mapControllerCompleter.complete(controller);
        _mapController = controller;

        // 현재 위치 마커 추가
        _addCurrentLocationMarker(widget.initialPosition);
        // 스토어 마커 추가
        _addStoreMarkers(widget.storePositions, widget.storeNames);
      },
    );
  }
}
