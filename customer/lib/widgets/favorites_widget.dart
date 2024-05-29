import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_customer/screens/restaurant_screens/restaurant_screen.dart';

class FavoritesWidget extends StatefulWidget {
  const FavoritesWidget({
    super.key,
    required this.salesStatus,
    required this.favoriteRestaurant,
    required this.favoritesLocation,
    required this.initialIsSubscribed,
  });
  final String salesStatus, favoriteRestaurant, favoritesLocation;
  final bool initialIsSubscribed;
  @override
  State<FavoritesWidget> createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends State<FavoritesWidget> {
  late bool isSubscribed;

  @override
  void initState() {
    super.initState();
    isSubscribed = widget.initialIsSubscribed;
    print('initState: isSubscribed = $isSubscribed');
  }

  void _toggleSubscribedStatus() {
    setState(() {
      isSubscribed = !isSubscribed;
      print('Toggle: isSubscribed = $isSubscribed');
    });
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
              builder: (context) => const RestaurantScreen(
                    storeId: 1,
                  )),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          border: Border(
            bottom: BorderSide(color: Colors.black12, width: 1),
          ),
        ),
        width: screenWidth,
        height: 0.2 * screenHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.03,
            horizontal: screenWidth * 0.047,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '현재판매상태: (${widget.salesStatus})',
                    style: TextStyle(
                      color:
                          isSubscribed ? Colors.black : const Color(0xFF828282),
                      fontSize: screenHeight * 0.017,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 0.026 * screenHeight),
                  Text(
                    widget.favoriteRestaurant,
                    style: TextStyle(
                      color:
                          isSubscribed ? Colors.black : const Color(0xFF828282),
                      fontSize: screenHeight * 0.03,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    widget.favoritesLocation,
                    style: TextStyle(
                      color:
                          isSubscribed ? Colors.black : const Color(0xFF828282),
                      fontSize: screenHeight * 0.018,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: _toggleSubscribedStatus,
                    icon: Icon(
                      isSubscribed ? Icons.favorite : Icons.favorite_border,
                      color: isSubscribed ? Colors.black : Colors.grey,
                      size: screenHeight * 0.04,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
