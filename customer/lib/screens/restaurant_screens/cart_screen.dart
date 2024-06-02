import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/models/order_model.dart';
import 'package:leftover_is_over_customer/services/order_services.dart';

class CartScreen extends StatefulWidget {
  final int storeId;
  final List<FoodOrder> foodOrders;
  final List<String> nameList;
  final List<int> priceList;

  int totalPrice = 0;

  void calculateTotalPrice() {
    int total = 0;
    for (int i = 0; i < foodOrders.length; i++) {
      total += foodOrders[i].count * priceList[i];
    }
    totalPrice = total;
  }

  CartScreen({
    super.key,
    required this.storeId,
    required this.foodOrders,
    required this.nameList,
    required this.priceList,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    widget.calculateTotalPrice(); // Call calculateTotalPrice method

    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('장바구니'),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: widget.foodOrders.isEmpty
          ? const Center(
              child: Text(
                '장바구니가 비어 있습니다.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: widget.foodOrders.length,
                itemBuilder: (context, index) {
                  final foodOrder = widget.foodOrders[index];
                  final menuName = widget.nameList[index];
                  final price = widget.priceList[index];
                  final itemCount = foodOrder.count;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CartItemWidget(
                        menuName: menuName,
                        price: '₩${price.toString()}',
                        itemCount: itemCount.toString(),
                        onRemove: () {
                          setState(() {
                            widget.foodOrders.removeAt(index);
                            widget.nameList.removeAt(index);
                            widget.priceList.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          width: screenWidth * 0.8,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (widget.foodOrders.isNotEmpty) {
                _createOrderRequest(widget.storeId, widget.foodOrders);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffFFC658),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: Text(
              '${widget.totalPrice}₩ 주문하기',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 주문 신청 할 때
  void _createOrderRequest(int storeId1, List<FoodOrder> foodOrders) async {
    bool success = await OrderService.placeOrder(
      storeId: storeId1,
      food: foodOrders,
      appPay: false,
    );

    if (success) {
      if (mounted) {
        if (mounted) {
          var message = '주문 등록에 성공했습니다';
          print(message);
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    } else {
      var message = '주문 등록에 실패했습니다';
      if (mounted) {
        print(message);
      }
    }
  }
}

class CartItemWidget extends StatelessWidget {
  final String menuName;
  final String price;
  final String itemCount;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.menuName,
    required this.price,
    required this.itemCount,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                menuName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '가격: $price',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                '수량: $itemCount',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle, color: Colors.red),
          onPressed: onRemove,
        ),
      ],
    );
  }
}
