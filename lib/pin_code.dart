import 'package:digitech_otp/sign_in/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import './constants/constants.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
class VerifiedScreen extends StatefulWidget {
  @override
  _VerifiedScreenState createState() => _VerifiedScreenState();
  final User user;

  const VerifiedScreen({required this.user});
}

class _VerifiedScreenState extends State<VerifiedScreen> {
  TextEditingController textEditingController = TextEditingController();


  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.PRIMARY_COLOR,
      bottomNavigationBar: GestureDetector(
        onTap: ()  async {
          setState(() {
            _isSigningOut = true;
          });
          await FirebaseAuth.instance.signOut();
          setState(() {
            _isSigningOut = false;
          });
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.topToBottom,
              child: SignInScreen(),
            ),
          );

        },
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "logout",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              Container(
                child: ClipRRect(
                  child: Image.asset(
                    "${Constants.OTP_GIF_IMAGE}",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Congratulations!',
                  style: headingStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: Text(
                    "You have Successfully completed the sign up process! We hope you enjoy our services!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black38,
                        fontSize: 19,
                        fontWeight: FontWeight.w300)),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
