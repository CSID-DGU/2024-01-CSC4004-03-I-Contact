import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({
    super.key,
    required this.restaurantName,
    required this.menuName,
    required this.price,
    required this.itemCount,
    required this.onRemove,
  });
  final String restaurantName, menuName, price, itemCount;
  final VoidCallback onRemove;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  void _removeItem() {
    widget.onRemove();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Container(
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
          vertical: screenHeight * 0.015,
          horizontal: screenWidth * 0.03,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/chicken.jpg', // 이미지 경로를 적절히 변경하세요
                width: 0.33 * screenWidth,
                height: 0.107 * screenHeight,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 0.03 * screenWidth),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.restaurantName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenHeight * 0.023,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.01 * screenHeight),
                  Text(
                    widget.menuName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 0.01 * screenHeight),
                  Text(
                    '가격: ${widget.price}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenHeight * 0.017,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 0.01 * screenHeight),
                  Text(
                    '신청갯수: ${widget.itemCount}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenHeight * 0.017,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _removeItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0EFFF),
                    foregroundColor: Colors.black,
                    textStyle: TextStyle(
                      fontSize: screenHeight * 0.02,
                    ),
                    minimumSize: const Size(90, 40),
                  ),
                  child: const Text('취소'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
