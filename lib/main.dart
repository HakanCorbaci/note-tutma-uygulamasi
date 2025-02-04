import 'package:flutter/material.dart';
import 'package:note/pages/splash_screen.dart';
import 'package:toastification/toastification.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}
