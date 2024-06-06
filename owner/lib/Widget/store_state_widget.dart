import 'package:flutter/material.dart';

// 매장의 현재 상태를 AppBar아래에 보여주는 위젯
// 추후 매장의 상태를 서버로 보내서
//페이지 이동 및 앱 재시작시에도 상태가 유지되도록 수정 필요

class ShowSalesStatus extends StatelessWidget {
  final bool isOpen;
  const ShowSalesStatus({
    super.key,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          const Text(
            '현재상태: ',
            style: TextStyle(
              fontFamily: "SubMenu",
              color: Color.fromARGB(255, 120, 120, 120),
            ),
          ),
          Text(
            isOpen ? "판매 중" : "판매 마감",
            style: TextStyle(
              fontFamily: "SubMenu",
              color: isOpen ? const Color.fromARGB(255, 0, 162, 0) : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
