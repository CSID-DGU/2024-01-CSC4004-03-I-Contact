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
    _futureStore =
        CategorySearchService.getStoreListBycategoryId(widget.categoryNumber);
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
            List<StoreModel> storeIds = snapshot.data!;
            return ListView.builder(
              itemCount: storeIds.length,
              itemBuilder: (BuildContext context, int index) {
                int storeId = index + 1; // storeId를 1부터 시작하도록 설정
                return RestaurantWidget(storeId: storeId);
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
