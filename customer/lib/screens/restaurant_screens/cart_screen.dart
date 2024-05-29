import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [
    {
      'restaurantName': '식당123',
      'menuName': '치킨',
      'price': '₩10,000',
      'itemCount': '2',
    },
    {
      'restaurantName': '식당124',
      'menuName': '피자',
      'price': '₩12,000',
      'itemCount': '1',
    },
    {
      'restaurantName': '식당125',
      'menuName': '햄버거',
      'price': '₩8,000',
      'itemCount': '3',
    },
    // Add more items here
  ];

  void handleItemRemove(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text('장바구니'),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: cartItems.isEmpty
            ? const Center(child: Text('장바구니가 비어 있습니다.'))
            : ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return CartItemWidget(
                    restaurantName: item['restaurantName'],
                    menuName: item['menuName'],
                    price: item['price'],
                    itemCount: item['itemCount'],
                    onRemove: () => handleItemRemove(index),
                  );
                },
              ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            width: screenWidth,
            height: screenHeight * 0.03, // 버튼 높이 조절
            margin: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
                vertical: screenHeight * 0.005), // 좌우 및 상하 간격 조절
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                '10000원 주문',
                style: TextStyle(
                  fontSize: screenHeight * 0.025,
                ),
              ),
            ),
          ),
        ));
  }
}
