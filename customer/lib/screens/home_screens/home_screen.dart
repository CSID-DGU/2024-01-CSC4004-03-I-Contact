import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_customer/screens/search_screens/category_search_screen.dart';
import 'package:leftover_is_over_customer/screens/home_screens/main_screen.dart';
import 'package:leftover_is_over_customer/screens/home_screens/map_screen.dart';
import 'package:leftover_is_over_customer/screens/search_screens/notifications_screen.dart';
import 'package:leftover_is_over_customer/screens/search_screens/search_screen.dart';
import 'package:leftover_is_over_customer/services/auth_services.dart';
import 'package:leftover_is_over_customer/models/user_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:leftover_is_over_customer/models/store_model.dart';
import 'package:leftover_is_over_customer/services/store_services.dart';

import '../../widgets/food_category_widget.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onMapTap;

  const HomeScreen(
      {super.key, required this.onProfileTap, required this.onMapTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<UserModel> _futureData = AuthService.getUserModel();
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
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        margin: EdgeInsets.only(
            top: screenHeight * 0.025,
            left: screenHeight * 0.025,
            right: screenHeight * 0.025),
        child: Column(
          children: [
            FutureBuilder<UserModel>(
              future: _futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  UserModel user = snapshot.data!;
                  return SizedBox(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.1,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: widget.onProfileTap,
                          child: Container(
                            width: screenWidth * 0.15,
                            height: screenWidth * 0.15,
                            margin: EdgeInsets.all(screenWidth * 0.02),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColorDark,
                                  width: 2),
                              borderRadius: BorderRadius.circular(45),
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.person_2_rounded,
                              size: screenWidth * 0.1,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                        Container(
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.1,
                          margin: EdgeInsets.all(screenWidth * 0.02),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45)),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              user.name,
                              style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationsScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: screenWidth * 0.1,
                            height: screenHeight * 0.1,
                            margin: EdgeInsets.only(left: screenWidth * 0.1),
                            child: Icon(
                              Icons.notifications,
                              size: 32,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No data found'),
                  );
                }
              },
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              child: Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.06,
                margin: const EdgeInsets.only(
                    top: 5, bottom: 20, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(45),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 2.0,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.all(7)),
                      Icon(
                        Icons.search,
                        size: 32,
                        color: Colors.black38,
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Text(
                        '검색',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black38),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.22,
              margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 2.0,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '    카테고리',
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * 0.03,
                        ),
                        const FoodCategoryWidget(
                            categoryNumber: 0, foodName: '한식'),
                        const FoodCategoryWidget(
                            categoryNumber: 1, foodName: '중식'),
                        const FoodCategoryWidget(
                            categoryNumber: 2, foodName: '일식'),
                        const FoodCategoryWidget(
                            categoryNumber: 3, foodName: '양식'),
                        const FoodCategoryWidget(
                            categoryNumber: 4, foodName: '패스트푸드'),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * 0.03,
                        ),
                        const FoodCategoryWidget(
                            categoryNumber: 5, foodName: '아시안'),
                        const FoodCategoryWidget(
                            categoryNumber: 6, foodName: '분식'),
                        const FoodCategoryWidget(
                            categoryNumber: 7, foodName: '디저트'),
                        const FoodCategoryWidget(
                            categoryNumber: 8, foodName: '기타'),
                        const FoodCategoryWidget(
                            categoryNumber: 9, foodName: '추천'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.42,
              margin: const EdgeInsets.only(bottom: 15, left: 5, right: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 2.0,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: NaverMapApp(
                initialPosition: _currentPosition!,
                storePositions: _storePositions,
                storeNames: _storeNames,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
