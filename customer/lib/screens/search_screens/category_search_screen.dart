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

  @override
  void initState() {
    super.initState();
    _futureStore = CategorySearchService.getStoreListByCategoryId(
        widget.categoryNumber, 37.55826385529836, 126.99853613087079);
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
