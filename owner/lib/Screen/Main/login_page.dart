import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:leftover_is_over_owner/Screen/Main/main_page.dart';
import 'package:leftover_is_over_owner/Screen/Search/search_select_page.dart';
import 'package:leftover_is_over_owner/Screen/Register/register_page.dart';
import 'package:leftover_is_over_owner/Screen/Register/store_register_page.dart';
import 'package:leftover_is_over_owner/Services/auth_services.dart';
import 'package:leftover_is_over_owner/Widget/show_custom_dialog_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController controllerUsername, controllerPwd;
  bool isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    controllerUsername = TextEditingController();
    controllerPwd = TextEditingController();
  }

  void _login() async {
    // 로그인 버튼이 눌릴 시 호출되는 함수
    setState(() {
      isLoading = true;
    });
    var login = await AuthService.login(
      username: controllerUsername.text,
      password: controllerPwd.text,
    );
    setState(() {
      isLoading = false;
    });
    if (login) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
        (Route<dynamic> route) => false,
      );
    } else {
      if (!mounted) {
        return;
      }
      showErrorDialog(context, '아이디/Password를 확인해주세요.');
    }
  }

  Future<void> _loginWithGoogle() async {
    print('로그인 시작');
    setState(() {
      isLoading = true;
    });

    try {
      // Trigger the authentication flow
      print('Google Sign-In 시작');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google Sign-In 취소됨');
        setState(() {
          isLoading = false;
        });
        return; // 사용자가 로그인 취소
      }

      // Obtain the auth details from the request
      print('Google Sign-In 성공: ${googleUser.email}');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Firebase 인증 시작');
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        print('Firebase 인증 성공: ${user.email}');
        // Check if user is signing in for the first time
        String googleId = "";
        String googleName = "";
        if (userCredential.additionalUserInfo!.isNewUser) {
          print('신규 회원');
          googleId = user.email!; // 사용자의 고유 Google ID
          googleName =
              googleUser.displayName ?? '사장님'; // 사용자의 이름이 없을 경우 '사장님'으로 설정

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => StoreRegisterPage(
                    googleId: googleId, googleName: googleName),
              ),
              (Route<dynamic> route) => false);
        } else {
          print('계정이 있는 회원');
          setState(() {
            isLoading = true;
          });
          var temp = "google";
          var login =
              await AuthService.login(username: user.email!, password: temp);
          setState(() {
            isLoading = true;
          });
          print("로그인 여부$login");
          if (login) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
              (Route<dynamic> route) => false,
            );
          } else {
            if (!mounted) {
              return showErrorDialog(context, '아이디/Password를 확인해주세요.');
            }
          }
        }
      } else {
        print('Firebase 사용자 없음');
      }
    } catch (e) {
      print('예외 발생: $e');
      showErrorDialog(context, 'Google 로그인에 실패했습니다.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 198, 88),
        body: isLoading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '로그인 중..',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min, // Column의 높이를 최소로 설정
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Loio',
                          style: TextStyle(
                            fontSize: 50,
                            color: Color.fromARGB(255, 82, 59, 42),
                            fontFamily: "Logo",
                          ),
                        ),
                      ),
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 100.0,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          '로그인',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: "Logo",
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            height: 55,
                            width: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'ID',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              autofocus: false,
                              controller: controllerUsername,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 55,
                            width: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              obscureText: true,
                              autofocus: false,
                              controller: controllerPwd,
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          SizedBox(
                            width: 300.0,
                            height: 50.0,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    const Color.fromARGB(255, 222, 234, 187)),
                              ),
                              onPressed: _login,
                              child: const Text(
                                '로그인',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: "MainButton",
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          SizedBox(
                            width: 300.0,
                            height: 50.0,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    const Color.fromARGB(255, 173, 190, 122)),
                              ),
                              onPressed: _loginWithGoogle,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_circle_rounded,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    '구글 계정으로 로그인',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: "MainButton",
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterPage()));
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                ),
                                child: const Text('회원 가입'),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('|'),
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SearchSelectPage()));
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                ),
                                child: const Text('ID/Password 찾기'),
                              ),
                            ],
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
