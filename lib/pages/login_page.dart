import 'package:flutter/material.dart';
import 'package:note/models/user.dart';
import 'package:note/pages/home_page.dart';
import 'package:note/pages/register_page.dart';
import 'package:note/services/database.dart';
import 'package:toastification/toastification.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.teal, Colors.greenAccent],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: Image.asset('images/logo.png'),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      int id = await loginUser(
                        User(
                          email: emailController.text,
                          password: passwordController.text,
                          username: "",
                        ),
                      );

                      bool result = id != 0;

                      if (result) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(userId: id),
                          ),
                        );
                        return;
                      }

                      toastification.show(
                        type: result
                            ? ToastificationType.success
                            : ToastificationType.error,
                        style: ToastificationStyle.flat,
                        autoCloseDuration: const Duration(seconds: 5),
                        title: Text(result ? 'Success' : 'Error'),
                        // you can also use RichText widget for title and description parameters
                        description: RichText(
                          text: TextSpan(
                            text: result
                                ? 'Registration Successful'
                                : 'Registration Failed, Please Try Again with different Credentials',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        alignment: Alignment.topRight,
                        direction: TextDirection.ltr,
                        animationDuration: const Duration(milliseconds: 300),
                        icon: result ? Icon(Icons.check) : Icon(Icons.error),
                        showIcon: true, // show or hide the icon
                        primaryColor: result ? Colors.green : Colors.red,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x07000000),
                            blurRadius: 16,
                            offset: Offset(0, 16),
                            spreadRadius: 0,
                          )
                        ],
                        showProgressBar: true,
                        closeButtonShowType: CloseButtonShowType.onHover,
                        closeOnClick: false,
                        pauseOnHover: true,
                        dragToClose: true,
                        applyBlurEffect: true,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
