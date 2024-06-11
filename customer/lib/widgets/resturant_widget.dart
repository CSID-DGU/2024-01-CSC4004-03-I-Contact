import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/models/food_model.dart';
import 'package:leftover_is_over_customer/screens/restaurant_screens/restaurant_screen.dart';
import 'package:leftover_is_over_customer/services/store_services.dart';
import 'package:leftover_is_over_customer/models/store_model.dart';
import 'package:leftover_is_over_customer/services/food_services.dart';

class RestaurantWidget extends StatefulWidget {
  final int storeId;

  const RestaurantWidget({super.key, required this.storeId});

  @override
  State<RestaurantWidget> createState() => _RestaurantWidgetState();
}

class _RestaurantWidgetState extends State<RestaurantWidget> {
  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _fetchData();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    final storeFuture = StoreService.getStoreById(widget.storeId);
    final foodsFuture = FoodService.getFoodListByStoreId(widget.storeId);

    final results = await Future.wait([storeFuture, foodsFuture]);

    return {
      'store': results[0],
      'foods': results[1],
    };
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return FutureBuilder<Map<String, dynamic>>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final store = snapshot.data!['store'] as StoreModel;
          final foods = snapshot.data!['foods'] as List<FoodModel>;

          int totalCapacity = foods.fold(0, (sum, food) => sum + food.capacity);

          // 여기서 데이터를 사용하여 원하는 위젯을 생성하고 반환합니다.
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantScreen(
                    storeId: store.storeId,
                  ),
                ),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.black12, width: 1),
                ),
              ),
              width: screenWidth,
              height: 0.25 * screenHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenHeight * 0.032,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      store.address,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: screenHeight * 0.022,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.015,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 예시 코드에서 사용한 ClipRRect 및 Image.asset 위젯을 여기에 추가합니다.
                        // 필요한 경우 foods 리스트를 사용하여 동적으로 위젯을 생성할 수 있습니다.
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: foods.isNotEmpty &&
                                  foods[0].imageUrl.isNotEmpty
                              ? Image.network(
                                  'http://loio-server.azurewebsites.net${foods[0].imageUrl}',
                                  width: 0.25 * screenWidth,
                                  height: 0.09 * screenHeight,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/chicken.jpg',
                                      width: 0.25 * screenWidth,
                                      height: 0.09 * screenHeight,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/chicken.jpg',
                                  width: 0.25 * screenWidth,
                                  height: 0.09 * screenHeight,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: foods.length > 1 &&
                                  foods[1].imageUrl.isNotEmpty
                              ? Image.network(
                                  'http://loio-server.azurewebsites.net${foods[1].imageUrl}',
                                  width: 0.25 * screenWidth,
                                  height: 0.09 * screenHeight,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/chicken.jpg',
                                      width: 0.25 * screenWidth,
                                      height: 0.09 * screenHeight,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/chicken.jpg',
                                  width: 0.25 * screenWidth,
                                  height: 0.09 * screenHeight,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: foods.length > 2 &&
                                  foods[2].imageUrl.isNotEmpty
                              ? Image.network(
                                  'http://loio-server.azurewebsites.net${foods[2].imageUrl}',
                                  width: 0.25 * screenWidth,
                                  height: 0.09 * screenHeight,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/chicken.jpg',
                                      width: 0.25 * screenWidth,
                                      height: 0.09 * screenHeight,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/chicken.jpg',
                                  width: 0.25 * screenWidth,
                                  height: 0.09 * screenHeight,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
