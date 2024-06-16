import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/services/store_services.dart';
import 'package:leftover_is_over_customer/models/store_model.dart';
import 'package:leftover_is_over_customer/widgets/resturant_widget.dart';

class CategorySearchScreen extends StatefulWidget {
  final String foodName;
  final int categoryNumber;

  const CategorySearchScreen(
      {super.key, required this.foodName, required this.categoryNumber});

  @override
  _CategorySearchScreenState createState() => _CategorySearchScreenState();
}

class _CategorySearchScreenState extends State<CategorySearchScreen> {
  late Future<List<StoreModel>> _futureStore;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _futureStore = Future.value([]); // 초기값으로 빈 리스트를 가진 Future 할당
    _initializeStoreList();
  }

  Future<void> _initializeStoreList() async {
    try {
      _currentPosition = await _getCurrentLocation();
      setState(() {
        if (widget.categoryNumber == 9) {
          _futureStore = LocationSearchService.getStoreListByLocation(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          );
        } else {
          _futureStore = CategorySearchService.getStoreListByCategoryId(
            widget.categoryNumber,
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          );
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodName),
      ),
      body: FutureBuilder<List<StoreModel>>(
        future: _futureStore,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<StoreModel> stores = snapshot.data!;
            if (stores.isEmpty) {
              return const Center(child: Text('식당이 없습니다.'));
            } else {
              return ListView.builder(
                itemCount: stores.length,
                itemBuilder: (BuildContext context, int index) {
                  final StoreModel store = stores[index];
                  return RestaurantWidget(storeId: store.storeId);
                },
              );
            }
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
