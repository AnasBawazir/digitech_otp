import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../size_config.dart';
import '../../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpForm extends StatefulWidget {
  final User user;
  const OtpForm({Key? key,required this.user}) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> with TickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();


  String currentText = "";
  final formKey = GlobalKey<FormState>();
  late Animation animation;
  late AnimationController animationController;
  FocusNode? pin1FocusNode;
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;

  double size1= 0.0;
  double size2= 0.0;
  double size3= 0.0;
  double size4= 0.0;
  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.ease);

    animation = Tween(begin: 0.0, end: 60.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
    pin1FocusNode = FocusNode();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
  }

  void nextField(
      {required String value, FocusNode? focusNodeNext, FocusNode? focusNodeBack}) {
    if (value.length == 1) {
      focusNodeNext!.requestFocus();
    }
    else if(value.length == 0){
      focusNodeBack!.requestFocus();
    }
    animationController.forward();
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    width: animation.value,
                    height: animation.value,
                    child: TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      showCursor: false,
                      focusNode: pin1FocusNode,
                      autofocus: true,
                      style: TextStyle(
                          fontSize: 32,
                          color: kPrimaryLightColor,
                          fontWeight: FontWeight.w900),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        nextField(value: value,focusNodeNext:  pin2FocusNode);
                      },
                    ),
                  ),
                  Container(
                    height: animation.value > 0  ? 0.0 : 15.0,
                    width: animation.value > 0 ? 0.0 : 15.0,
                    decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    width: animation.value > 0  ? animation.value : 0.0 ,
                    height: animation.value > 0  ? animation.value : 0.0,
                    child: TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      focusNode: pin2FocusNode,
                      showCursor: false,
                      style: TextStyle(
                          fontSize: 32,
                          color: kPrimaryLightColor,
                          fontWeight: FontWeight.w900),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        nextField(value: value,focusNodeNext:  pin3FocusNode,focusNodeBack: pin1FocusNode);
                      },
                    ),
                  ),
                  Container(
                    height: animation.value > 0  ? 0.0 : 15.0,
                    width: animation.value > 0 ? 0.0 : 15.0,
                    decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    width: animation.value > 0  ? animation.value : 0.0 ,
                    height: animation.value > 0  ? animation.value : 0.0,
                    child: TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      focusNode: pin3FocusNode,
                      showCursor: false,
                      style: TextStyle(
                          fontSize: 32,
                          color: kPrimaryLightColor,
                          fontWeight: FontWeight.w900),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        nextField(value: value, focusNodeNext: pin4FocusNode,focusNodeBack: pin3FocusNode);
                      },
                    ),
                  ),
                  Container(
                    height: animation.value > 0  ? 0.0 : 15.0,
                    width: animation.value > 0 ? 0.0 : 15.0,
                    decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    width:animation.value > 0  ? animation.value : 0.0 ,
                    height: animation.value > 0  ? animation.value : 0.0,
                    child: TextFormField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      focusNode: pin4FocusNode,
                      showCursor: false,
                      style: TextStyle(
                          fontSize: 32,
                          color: kPrimaryLightColor,
                          fontWeight: FontWeight.w900),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: otpInputDecoration,
                      onChanged: (value) {
                        if (value.length == 1) {
                         // pin4FocusNode!.unfocus();
                          // Then you need to check is the code is correct or not
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerifiedScreen()));
                        }                      },
                    ),
                  ),
                  Container(
                    height: animation.value > 0  ? 0.0 : 15.0,
                    width: animation.value > 0 ? 0.0 : 15.0,
                    decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.15),
        ],
      ),
    );
  }
}

