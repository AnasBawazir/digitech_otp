import 'package:digitech_otp/otp/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:digitech_otp/components/custom_surfix_icon.dart';
import 'package:digitech_otp/components/default_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../size_config.dart';
import 'package:digitech_otp/utils/validator.dart';
import 'package:digitech_otp/utils/fire_auth.dart';


class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? name;
  String? password;
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          SizedBox(height: getProportionateScreenHeight(40)),
          _isProcessing
              ? CircularProgressIndicator()
              : DefaultButton(
            text: "Register",
            press: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              if (_formKey.currentState!
                  .validate()) {
                setState(() {
                  _isProcessing = true;
                });
                User? user = await FireAuth
                    .registerUsingEmailPassword(
                  name: _nameTextController.text,
                  email: _emailTextController.text,
                  password:
                  _passwordTextController.text,
                );

                setState(() {
                  _isProcessing = false;
                });

                if (user != null) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => OtpScreen(user: user,)));
                }
              }
            }
            ,
          ),
        ],
      ),
    );
  }


  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      controller: _passwordTextController,
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
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextController,
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
  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: _nameTextController,
      validator: (value) => Validator.validateName(
        name: value,
      ),
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter your name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

}
