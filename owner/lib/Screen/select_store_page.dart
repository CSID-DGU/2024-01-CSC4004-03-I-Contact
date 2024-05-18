import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_owner/Screen/main_page.dart';

class SelectStore extends StatefulWidget {
  const SelectStore({super.key});

  @override
  State<SelectStore> createState() => _ChooseStoreState();
}

class _ChooseStoreState extends State<SelectStore> {
  String currentState = "판매 중";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 198, 88),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text(
                '매장을 선택하세요',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      // 매장 1과 매장 2
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            // 매장1 선택 -> 매장1 메인화면으로 이동
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainPage(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                _buildBox(),
                                const SizedBox(height: 8),
                                const Text(
                                  '매장 1',
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(height: 22),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              _buildBox(),
                              const SizedBox(height: 8),
                              const Text(
                                '매장 2',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 22),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      // 매장 3과 매장 4
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildBox(),
                              const SizedBox(height: 8),
                              const Text(
                                '매장 3',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 22),
                            ],
                          ),
                        ),
                        Expanded(
                          // 매장 추가 버튼
                          child: Column(
                            children: [
                              Stack(
                                // 아이콘과 배경원 겹치게 함
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 234, 234, 234),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.add_circle_outline_rounded,
                                        size: 70,
                                      )
                                      // 아이콘 크기를 조절하여 원과 정확하게 맞추기
                                      ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                ' ',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 22),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }

// 매장 버튼 만드는 함수
  _buildBox() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 234, 234, 234),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            offset: const Offset(0, 1),
            color: Colors.black.withOpacity(0.5),
          )
        ],
      ),
    );
  }
}
