import 'package:flutter/material.dart';
import 'package:leftover_is_over_owner/Services/api_services.dart';

class StoreRegisterPage extends StatefulWidget {
  const StoreRegisterPage({super.key});

  @override
  State<StoreRegisterPage> createState() => _StoreRegisterPageState();
}

class _StoreRegisterPageState extends State<StoreRegisterPage> {
  late TextEditingController controllerName,
      controllerStartTime,
      controllerEndTime,
      controllerAddress,
      controllerPhone;
  String selectedValue = '값을 선택해주세요';
  @override
  void initState() {
    controllerName = TextEditingController();
    controllerStartTime = TextEditingController();
    controllerEndTime = TextEditingController();
    controllerAddress = TextEditingController();
    controllerPhone = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.amber[600],
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '회원가입  ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 23),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[300]!.withOpacity(0.6),
                  ),
                  child: const Text(
                    '매장 이름',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  height: 36,
                  width: 400,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: const Offset(-2, 5),
                      )
                    ],
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(70.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    autofocus: true,
                    controller: controllerName, // 컨트롤러 예제에서는 주석 처리
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 23),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[300]!.withOpacity(0.6),
                  ),
                  child: const Text(
                    '개점 시간',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  height: 36,
                  width: 400,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: const Offset(-2, 5),
                      )
                    ],
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(70.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    autofocus: true,
                    controller: controllerStartTime,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(100, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        side: BorderSide(color: Colors.grey[700]!),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      child: const Text(
                        '중복 확인',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 23),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[300]!.withOpacity(0.6),
                  ),
                  child: const Text(
                    '마감 시간',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  height: 36,
                  width: 400,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: const Offset(-2, 5),
                      )
                    ],
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(70.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    autofocus: true,
                    controller: controllerEndTime,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 23),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[300]!.withOpacity(0.6),
                  ),
                  child: const Text(
                    '업종 분류',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  height: 36,
                  width: 400,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: const Offset(-2, 5),
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '   선택된 값',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (String value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('선택된 값: $value')));
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: '한식',
                            child: Text('한식'),
                          ),
                          const PopupMenuItem<String>(
                            value: '양식',
                            child: Text('양식'),
                          ),
                          const PopupMenuItem<String>(
                            value: '일식',
                            child: Text('일식'),
                          ),
                          const PopupMenuItem<String>(
                            value: '중식',
                            child: Text('중식'),
                          ),
                          // 추가 메뉴 아이템들...
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 23),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[300]!.withOpacity(0.6),
                  ),
                  child: const Text(
                    '주소',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Container(
                  height: 36,
                  width: 400,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: const Offset(-2, 5),
                      )
                    ],
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(70.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    autofocus: true,
                    controller: controllerAddress,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // 중복 확인 로직
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.green[300]!.withOpacity(0.6),
                        minimumSize: const Size(120, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        side: BorderSide(color: Colors.grey[200]!),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        '다음',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
