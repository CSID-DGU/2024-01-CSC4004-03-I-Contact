import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leftover_is_over_owner/Screen/Main/login_page.dart';
import 'package:leftover_is_over_owner/Screen/Main/main_page.dart';
import 'package:leftover_is_over_owner/Screen/Search/change_PW_complete.dart';
import 'package:leftover_is_over_owner/Screen/Search/search_PW_page.dart';

class SearchIdComplete extends StatefulWidget {
  final String searchId;
  const SearchIdComplete({required this.searchId, super.key});

  @override
  State<SearchIdComplete> createState() => _SearchIdCompleteState();
}

class _SearchIdCompleteState extends State<SearchIdComplete> {
  late TextEditingController controllerUsername;

  @override
  void initState() {
    super.initState();
    controllerUsername = TextEditingController();
    controllerUsername.text = widget.searchId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 198, 88),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50, bottom: 30),
            child: Text(
              'Loio',
              style: TextStyle(
                fontSize: 50,
                color: Color.fromARGB(255, 82, 59, 42),
                fontFamily: "Logo",
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ID 찾기 완료 ',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Free2",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 23),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 222, 234, 187),
                        ),
                        child: const Text(
                          '기존 아이디',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 36,
                  width: 300,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(1, 3),
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
                    autofocus: false,
                    readOnly: true,
                    controller: controllerUsername,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 170),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()),
                              (route) => false,
                            );

                            Future.delayed(Duration.zero, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangePwComplete()),
                              );
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                        ),
                        child: const Text('Password 찾기'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Center(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: SizedBox(
              width: 300.0,
              height: 60.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 173, 190, 122)),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text(
                  '로그인 화면으로 이동',
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: "MainButton",
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
