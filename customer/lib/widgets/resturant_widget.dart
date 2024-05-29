import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/screens/restaurant_screens/restaurant_screen.dart';
import 'package:leftover_is_over_customer/services/store_services.dart';
import 'package:leftover_is_over_customer/models/store_model.dart';

class RestaurantWidget extends StatefulWidget {
  final int storeId;

  const RestaurantWidget({super.key, required this.storeId});

  @override
  State<RestaurantWidget> createState() => _RestaurantWidgetState();
}

class _RestaurantWidgetState extends State<RestaurantWidget> {
  late Future<StoreModel> _futureStore;

  @override
  void initState() {
    super.initState();
    _futureStore = StoreService.getStoreById(widget.storeId);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return FutureBuilder<StoreModel>(
      future: _futureStore,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          StoreModel store = snapshot.data!;
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
                        fontWeight: FontWeight.w400,
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/images/chicken.jpg',
                            width: 0.25 * screenWidth,
                            height: 0.09 * screenHeight,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/images/chicken.jpg',
                            width: 0.25 * screenWidth,
                            height: 0.09 * screenHeight,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
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
