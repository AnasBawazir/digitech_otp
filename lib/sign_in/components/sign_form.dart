import 'package:digitech_otp/pin_code.dart';
import 'package:digitech_otp/sign_up/sign_up_screen.dart';
import 'package:digitech_otp/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:digitech_otp/components/custom_surfix_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';
import '../../../components/default_button.dart';
import '../../../size_config.dart';
import 'package:digitech_otp/utils/fire_auth.dart';

import '../../constants.dart';


class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;
    print("firebase initialize done");

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildEmailFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildPasswordFormField(),
                SizedBox(height: getProportionateScreenHeight(30)),
                SizedBox(height: getProportionateScreenHeight(20)),
                DefaultButton(
                  text: "Login",
                  press: () async {

                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isProcessing = true;
                      });

                      User? user = await FireAuth.signInUsingEmailPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      );

                      setState(() {
                        _isProcessing = false;
                      });

                      if (user != null) {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: VerifiedScreen(user: user,),
                          ),
                        );
                      }
                    }
                  },
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account? ",
                      style:
                      TextStyle(fontSize: getProportionateScreenWidth(16)),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: SignUpScreen(),
                        ),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(16),
                            color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
      },
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      focusNode: _focusPassword,
      obscureText: true,
      controller: _passwordTextController,
      onSaved: (newValue) => password = newValue,
      validator: (value) => Validator.validatePassword(
        password: value,
      ),
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      focusNode: _focusEmail,
      controller: _emailTextController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      validator: (value) => Validator.validateEmail(
        email: value,
      ),
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
