import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/services/store_services.dart';
import 'package:leftover_is_over_customer/models/store_model.dart';
import 'package:leftover_is_over_customer/services/favorite_services.dart';
import 'package:leftover_is_over_customer/screens/restaurant_screens/restaurant_screen.dart';

class FavoritesWidget extends StatefulWidget {
  const FavoritesWidget({
    super.key,
    required this.storeId,
    required this.initialIsSubscribed,
  });

  final int storeId;
  final bool initialIsSubscribed;

  @override
  State<FavoritesWidget> createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends State<FavoritesWidget> {
  late bool isSubscribed;
  late Future<StoreModel> storeFuture;

  @override
  void initState() {
    super.initState();
    isSubscribed = widget.initialIsSubscribed;
    storeFuture = StoreService.getStoreById(widget.storeId);
  }

  void _toggleSubscribedStatus() async {
    setState(() {
      isSubscribed = !isSubscribed;
    });

    if (isSubscribed) {
      bool success =
          await FavoriteService.makeFavorite(storeId: widget.storeId);
      if (!success) {
        setState(() {
          isSubscribed = !isSubscribed;
        });
      }
    } else {
      bool success =
          await FavoriteService.deleteFavorite(storeId: widget.storeId);
      if (!success) {
        setState(() {
          isSubscribed = !isSubscribed;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantScreen(
              storeId: widget.storeId,
            ),
          ),
        );
      },
      child: FutureBuilder<StoreModel>(
        future: storeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: screenWidth,
              height: 0.2 * screenHeight,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return SizedBox(
              width: screenWidth,
              height: 0.2 * screenHeight,
              child: const Center(
                child: Text('Failed to load store info'),
              ),
            );
          } else {
            StoreModel store = snapshot.data!;
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02,
                horizontal: screenWidth * 0.04,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              width: screenWidth,
              height: 0.17 * screenHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        store.open ? '판매 중' : '가게 마감',
                        style: TextStyle(
                          color: isSubscribed && store.open
                              ? Colors.black
                              : const Color(0xFF828282),
                          fontSize: screenHeight * 0.017,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.00),
                      Text(
                        store.name,
                        style: TextStyle(
                          color: isSubscribed
                              ? Colors.black
                              : const Color(0xFF828282),
                          fontSize: screenHeight * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        store.address,
                        style: TextStyle(
                          color: isSubscribed
                              ? Colors.black
                              : const Color(0xFF828282),
                          fontSize: screenHeight * 0.018,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: _toggleSubscribedStatus,
                    icon: Icon(
                      isSubscribed ? Icons.favorite : Icons.favorite_border,
                      color: isSubscribed ? Colors.red : Colors.grey,
                      size: screenHeight * 0.04,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
