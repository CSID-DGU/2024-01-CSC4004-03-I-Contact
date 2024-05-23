import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leftover_is_over_customer/widgets/favorites_widget.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        margin: const EdgeInsets.all(20),
        child: const Column(
          children: [
            Center(
              child: Text(
                '즐겨찾기 탭',
                style: TextStyle(fontSize: 40),
              ),
            ),
            FavoritesWidget(
              salesStatus: '판매중',
              favoriteRestaurant: '식당314',
              favoritesLocation: '충무로역100번출구',
              initialIsSubscribed: true,
            ),
            FavoritesWidget(
              salesStatus: '판매중지',
              favoriteRestaurant: '식당315',
              favoritesLocation: '충무로역99번출구',
              initialIsSubscribed: false,
            ),
          ],
        ),
      ),
    );
  }
}
