import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        margin: const EdgeInsets.all(20),
        child: const Column(
          children: [
            Center(
              child: Text(
                '검색 탭',
                style: TextStyle(fontSize: 40),
              ),
            )
          ],
        ),
      ),
    );
  }
}
