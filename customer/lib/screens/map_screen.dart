import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/widgets/resturant_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double _scrollviewHeight = 300.0; // Initial height of the scroll view
  final double _minHeight = 0.0; // Minimum height of the scroll view
  final double _maxHeight = 500.0; // Maximum height of the scroll view

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('지도 탭'),
      ),
      body: Stack(
        children: [
          // Map widget
          Container(
            color: Colors.blue, // Example color for the map
            // Add your map widget here
          ),
          // Draggable scroll view
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                // Check if the touch position is within the SizedBox area
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                Offset localPosition =
                    renderBox.globalToLocal(details.globalPosition);
                bool isWithinSizedBox = localPosition.dy >
                    MediaQuery.of(context).size.height - _scrollviewHeight;

                if (!isWithinSizedBox) {
                  setState(() {
                    _scrollviewHeight -= details.primaryDelta!;
                    _scrollviewHeight = _scrollviewHeight.clamp(
                      _minHeight,
                      _maxHeight,
                    );
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _scrollviewHeight,
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      color: Colors.grey,
                      child: const SizedBox(
                        height: 25,
                      ),
                    ),
                    // Add your scroll view content here
                    const ListTile(
                      title: RestaurantWidget(
                        restaurantName: '식당1',
                        restaurantLocation: '위치1',
                      ),
                    ),
                    const ListTile(
                      title: RestaurantWidget(
                        restaurantName: '식당2',
                        restaurantLocation: '위치2',
                      ),
                    ),
                    const ListTile(
                      title: RestaurantWidget(
                        restaurantName: '식당3',
                        restaurantLocation: '위치3',
                      ),
                    ),
                    // Add more RestaurantWidget items as needed
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
