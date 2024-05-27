import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/widgets/menu_widget.dart';
import 'cart_screen.dart';

class RestaurantScreen extends StatefulWidget {
  final String restaurantName;

  const RestaurantScreen({super.key, required this.restaurantName});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  bool isFavorite = false; // Track the favorite state
  int numServings = 1;

  void _showHalfScreenModal(String menuName) {
    setState(() {
      numServings = 1; // Reset numServings to 1 when the modal is shown
    });

    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return FractionallySizedBox(
              heightFactor: 0.4,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.035),
                            child: Text(
                              '$menuName 주문하기',
                              style: TextStyle(fontSize: screenHeight * 0.035),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (numServings > 1) {
                                    setModalState(() {
                                      numServings -= 1;
                                    });
                                  }
                                },
                                child: SizedBox(
                                  width: screenHeight * 0.04,
                                  height: screenHeight * 0.04,
                                  child: Icon(
                                    Icons.exposure_minus_1_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.1,
                              ),
                              Text(
                                '$numServings인분',
                                style: TextStyle(fontSize: screenHeight * 0.04),
                              ),
                              SizedBox(
                                width: screenWidth * 0.1,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setModalState(() {
                                    numServings += 1;
                                  });
                                },
                                child: SizedBox(
                                  width: screenHeight * 0.04,
                                  height: screenHeight * 0.04,
                                  child: Icon(
                                    Icons.plus_one_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: screenHeight * 0.035),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('$menuName이 장바구니에 추가되었습니다.'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Theme.of(context).primaryColor,
                                fixedSize: Size(
                                    screenWidth * 0.8, screenHeight * 0.06),
                              ),
                              child: Text(
                                '장바구니에 추가',
                                style: TextStyle(
                                  fontSize: screenHeight * 0.027,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

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
                    right: screenWidth * 0.07,
                  ),
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
                      SizedBox(height: screenHeight * 0.02),
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
              onMenuTap: (String menuName) {
                _showHalfScreenModal(menuName);
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          width: screenWidth,
          height: screenHeight * 0.08, // 버튼 높이 조절
          margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.01), // 좌우 및 상하 간격 조절
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.white,
            ),
            child: Text(
              '장바구니',
              style: TextStyle(
                fontSize: screenHeight * 0.025,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
