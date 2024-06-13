import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/widgets/favorites_widget.dart';
import 'package:leftover_is_over_customer/services/favorite_services.dart';
import 'package:leftover_is_over_customer/models/favorite_model.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<FavoriteModel>> favoriteFuture;

  @override
  void initState() {
    super.initState();
    favoriteFuture = FavoriteService.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('즐겨찾기', style: TextStyle(fontWeight: FontWeight.w600))),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: FutureBuilder<List<FavoriteModel>>(
          future: favoriteFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Failed to load favorites: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No favorites found.'));
            } else {
              List<FavoriteModel> favorites = snapshot.data!;
              return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return FavoritesWidget(
                    storeId: favorites[index].storeId,
                    initialIsSubscribed:
                        true, // Assuming all fetched favorites are initially subscribed
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
