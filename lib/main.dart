import 'package:flutter/material.dart';
import 'package:hyperdesk/presentation/screens/main_screen.dart';
import 'package:hyperdesk/presentation/widgets/explorer.dart';
import 'package:hyperdesk/presentation/widgets/windows_dialog.dart';

void main() {
  runApp(MyHomeLauncher());
}

class MyHomeLauncher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark(),
      initialRoute: '/main',
      routes: {
        "/main": (context) => HomeScreen(),
        "/explorer": (context) => Explorer(),
        "/windows_dialog": (context) => WindowsDialog(),
      },
    );
  }
}
