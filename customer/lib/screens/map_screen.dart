import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/widgets/resturant_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double scrollviewHeight = 300.0; // 스크롤 뷰의 초기 높이

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    double minHeight = screenHeight * 0.03;
    double maxHeight = screenHeight * 0.815;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('지도')),
      ),
      body: Stack(
        children: [
          // Map widget
          Image.asset(
            'assets/images/rect_map.png',
            width: screenWidth,
            height: screenHeight,
            fit: BoxFit.cover,
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
