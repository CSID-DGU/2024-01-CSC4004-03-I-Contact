import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/models/store_model.dart';
import 'package:leftover_is_over_customer/services/store_services.dart';
import 'package:leftover_is_over_customer/widgets/resturant_widget.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double scrollviewHeight = 200.0; // 스크롤 뷰의 초기 높이
  late Future<List<StoreModel>> _futureStore;

  @override
  void initState() {
    super.initState();
    _futureStore = LocationSearchService.getStoreListByLocation(
        37.55826385529836, 126.99853613087079);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    double minHeight = screenHeight * 0.03;
    double maxHeight = screenHeight * 0.8;

    return Scaffold(
      body: FutureBuilder<List<StoreModel>>(
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
                const NaverMapApp(),
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
                            itemBuilder: (BuildContext context, int index) {
                              final StoreModel store =
                                  stores[index]; // storeId를 1부터 시작하도록 설정
                              return RestaurantWidget(storeId: store.storeId);
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
  const NaverMapApp({super.key});

  @override
  _NaverMapAppState createState() => _NaverMapAppState();
}

class _NaverMapAppState extends State<NaverMapApp> {
  final Completer<NaverMapController> _mapControllerCompleter = Completer();
  late NaverMapController _mapController;
  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
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

    _currentPosition = await Geolocator.getCurrentPosition();
    _addCurrentLocationMarker();
  }

  void _addCurrentLocationMarker() {
    if (_mapControllerCompleter.isCompleted) {
      final currentLocationMarker = NMarker(
        id: 'current_location',
        position: NLatLng(
          _currentPosition.latitude,
          _currentPosition.longitude,
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
              _currentPosition.latitude,
              _currentPosition.longitude,
            ),
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: NaverMap(
          onMapReady: (controller) {
            _mapControllerCompleter.complete(controller);
            _mapController = controller;

            final marker = NMarker(
              id: 'test',
              position: const NLatLng(
                37.506932467450326,
                127.05578661133796,
              ),
            );
            final marker1 = NMarker(
              id: 'test1',
              position: const NLatLng(
                37.606932467450326,
                127.05578661133796,
              ),
            );
            controller.addOverlayAll(
              {
                marker,
                marker1,
              },
            );

            final onMarkerInfoWindow = NInfoWindow.onMarker(
              id: marker.info.id,
              text: "멋쟁이 사자처럼",
            );
            marker.openInfoWindow(onMarkerInfoWindow);

            // 현재 위치 마커 추가
            _addCurrentLocationMarker();
          },
        ),
      ),
    );
  }
}
