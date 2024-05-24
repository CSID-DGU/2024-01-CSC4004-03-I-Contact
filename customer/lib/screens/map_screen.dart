import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/widgets/resturant_widget.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double scrollviewHeight = 200.0; // 스크롤 뷰의 초기 높이

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    double minHeight = screenHeight * 0.03;
    double maxHeight = screenHeight * 0.8;

    return Scaffold(
      body: Stack(
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
                  if (scrollviewHeight - details.primaryDelta! >= minHeight &&
                      scrollviewHeight - details.primaryDelta! <= maxHeight) {
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
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: const [
                        ListTile(
                          title: RestaurantWidget(
                            restaurantName: '식당1',
                            restaurantLocation: '위치1',
                          ),
                        ),
                        ListTile(
                          title: RestaurantWidget(
                            restaurantName: '식당2',
                            restaurantLocation: '위치2',
                          ),
                        ),
                        ListTile(
                          title: RestaurantWidget(
                            restaurantName: '식당3',
                            restaurantLocation: '위치3',
                          ),
                        ),
                        ListTile(
                          title: RestaurantWidget(
                            restaurantName: '식당4',
                            restaurantLocation: '위치4',
                          ),
                        ),
                        // 필요한 만큼 더 많은 RestaurantWidget 항목 추가
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NaverMapApp extends StatelessWidget {
  const NaverMapApp({super.key, Key? key2});

  @override
  Widget build(BuildContext context) {
    // NaverMapController 객체의 비동기 작업 완료를 나타내는 Completer 생성
    final Completer<NaverMapController> mapControllerCompleter = Completer();

    return MaterialApp(
      home: Scaffold(
        body: NaverMap(
          options: const NaverMapViewOptions(
            indoorEnable: true, // 실내 맵 사용 가능 여부 설정
            locationButtonEnable: false, // 위치 버튼 표시 여부 설정
            consumeSymbolTapEvents: false, // 심볼 탭 이벤트 소비 여부 설정
          ),
          onMapReady: (controller) async {
            // 지도 준비 완료 시 호출되는 콜백 함수
            mapControllerCompleter.complete(controller);
          },
        ),
      ),
    );
  }
}
