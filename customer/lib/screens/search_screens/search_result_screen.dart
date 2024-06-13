import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/services/store_services.dart';
import 'package:leftover_is_over_customer/models/store_model.dart';
import 'package:leftover_is_over_customer/widgets/resturant_widget.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;

  const SearchResultScreen({super.key, required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late Future<List<StoreModel>> _futureStore;

  @override
  void initState() {
    super.initState();
    _futureStore = GetStoreByKeywordService.getStoreListByKeyword(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색 : ${widget.query}'),
      ),
      body: FutureBuilder<List<StoreModel>>(
        future: _futureStore,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<StoreModel> storeList = snapshot.data!;
            return ListView.builder(
              itemCount: storeList.length,
              itemBuilder: (BuildContext context, int index) {
                final store = storeList[index];
                return RestaurantWidget(storeId: store.storeId);
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
