import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/services/store_services.dart';
import 'package:leftover_is_over_customer/models/store_model.dart';
import 'package:leftover_is_over_customer/widgets/resturant_widget.dart';

class CategorySearchScreen extends StatefulWidget {
  final String foodName;

  const CategorySearchScreen({super.key, required this.foodName});

  @override
  _CategorySearchScreenState createState() => _CategorySearchScreenState();
}

class _CategorySearchScreenState extends State<CategorySearchScreen> {
  late Future<List<int>> _futureStoreIds;

  @override
  void initState() {
    super.initState();
    _futureStoreIds = fetchStoreIdsByCategory(widget.foodName);
  }

  Future<List<int>> fetchStoreIdsByCategory(String category) async {
    // 여기에서 카테고리로 식당 ID 목록을 가져오는 로직을 추가
    // 예를 들어, http 요청을 통해 API에서 식당 ID 목록을 가져오는 방식
    // 여기서는 예시로 임의의 ID 목록을 반환
    return [1, 2, 3, 4, 5];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodName),
      ),
      body: FutureBuilder<List<int>>(
        future: _futureStoreIds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<int> storeIds = snapshot.data!;
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
