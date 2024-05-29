import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/widgets/resturant_widget.dart';

class SearchResultScreen extends StatelessWidget {
  final String query;

  const SearchResultScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색 : $query'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return const RestaurantWidget(storeId: 1);
        },
      ),
    );
  }
}
