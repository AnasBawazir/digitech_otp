import 'package:digitech_otp/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digitech OTP',
      theme: ThemeData(
        accentColor:  Color(0xFFfcbf20),
        primaryColor:  Color(0xFFfefefe),
      ),
      home: SignInScreen(),
    );
  }
}