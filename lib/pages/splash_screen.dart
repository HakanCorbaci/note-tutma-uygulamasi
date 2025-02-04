import 'package:flutter/material.dart';
import 'package:note/pages/home_page.dart';
import 'package:note/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate app initialization with a delay
    Future.delayed(Duration(seconds: 2), () async {
      SharedPreferences sp = await SharedPreferences.getInstance();
      int id = sp.getInt('id') ?? 0;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => id != 0 ? HomePage(userId: id) : LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade400,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Image.asset('images/logo.png'),
            ), // Replace with your app logo
            SizedBox(height: 20),
            Text(
              'My Awesome App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
