import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/widgets/menu_widget.dart';

class RestaurantScreen extends StatefulWidget {
  final String restaurantName;

  const RestaurantScreen({super.key, required this.restaurantName});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  bool isFavorite = false; // Track the favorite state

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: screenHeight * 0.3,
              floating: false,
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Image.asset(
                  'assets/images/chicken.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(
                      right: screenWidth * 0.05), // Adjust the padding here
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        // Toggle the favorite state
                        isFavorite = !isFavorite;
                      });
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      // Change icon based on favorite state
                      color: isFavorite
                          ? Colors.red
                          : null, // Highlight if favorite
                    ),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.2,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.01,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.07),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.restaurantName,
                        style: TextStyle(fontSize: screenHeight * 0.035),
                      ),
                      Text(
                        '위치',
                        style: TextStyle(
                            fontSize: screenHeight * 0.025,
                            color: Colors.black54),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Text(
                        '식수인원 N명',
                        style: TextStyle(fontSize: screenHeight * 0.02),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '이용예정 N명',
                                style: TextStyle(
                                  fontSize: screenHeight * 0.015,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '마감시간 23:00',
                                style: TextStyle(
                                  fontSize: screenHeight * 0.02,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return MenuWidget(
              menuName: '메뉴 $index',
              unitCost: '1000',
              remaining: '1',
            );
          },
        ),
      ),
    );
  }
}
