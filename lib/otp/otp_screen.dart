import 'package:flutter/material.dart';
import '../size_config.dart';
import 'components/body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../size_config.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";
  const OtpScreen({required this.user});
   final User user;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      //onTap: () =>FocusManager.instance.primaryFocus?.nextFocus(),
    child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Verify"),
      ),
      body: Body(user: user,),
    ),);
  }
}
