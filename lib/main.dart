import 'package:flutter/material.dart';
import 'package:hyperdesk/presentation/screens/main_screen.dart';


void main() {
  runApp(MyHomeLauncher());
}

class MyHomeLauncher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
