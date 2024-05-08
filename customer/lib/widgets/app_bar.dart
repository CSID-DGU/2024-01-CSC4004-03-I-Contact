import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Theme.of(context).primaryColor,
      title: const Text('Test'),
    );
  }
}
