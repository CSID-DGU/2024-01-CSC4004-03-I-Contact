import 'package:flutter/material.dart';
import 'package:leftover_is_over_customer/screens/main_screen.dart';

void main() {
  runApp(const App2());
}

class App2 extends StatelessWidget {
  const App2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              color: Color(0XFF523B2A),
            ),
          ),
          cardColor: const Color(0xffDEEABB),
          primaryColor: const Color(0xffFFC658),
          primaryColorDark: const Color(0XFF523B2A),
          primaryColorLight: const Color.fromARGB(255, 255, 246, 225),
          colorScheme: ColorScheme.fromSwatch(
              backgroundColor: const Color.fromARGB(255, 253, 255, 249)),
        ),
        home: const MainScreen());
  }
}
