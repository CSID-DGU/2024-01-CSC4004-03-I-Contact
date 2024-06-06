import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Model/order_model.dart';
import 'package:leftover_is_over_owner/Services/order_services.dart';
import 'package:leftover_is_over_owner/Services/store_services.dart';
import 'package:leftover_is_over_owner/Widget/order_card_widget.dart';
import 'package:leftover_is_over_owner/Widget/store_state_widget.dart';

class OrderManagePage extends StatefulWidget {
  const OrderManagePage({super.key});

  @override
  State<OrderManagePage> createState() => _OrderManagePageState();
}

class _OrderManagePageState extends State<OrderManagePage> {
  bool isLoading = true;
  late bool isOpen;
  late Future<List<OrderModel>> orderList;

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    orderList = OrderService.getOrderList(false); // visit인 오더리스트만 보이게
    _getStoreState();
  }

  Future<void> _getStoreState() async {
    isOpen = await StoreService.getStoreState();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 하단 버튼 칸의 비율을 유지하기 위함
    double bottomSheetHeight = MediaQuery.of(context).size.height * 0.03;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '이용 확인  ',
              style: TextStyle(
                fontSize: 24,
                fontFamily: "MainButton",
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: FutureBuilder<List<OrderModel>>(
                future: orderList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var order = snapshot.data![index];
                        return OrderCard(order);
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return const Center(child: Text('No orders available'));
                  }
                },
              ),
            ),
    );
  }
}
