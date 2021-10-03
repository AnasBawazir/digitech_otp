import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:digitech_otp/constants.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../pin_code.dart';
import '../../size_config.dart';
import 'package:email_auth/email_auth.dart';

class Body extends StatefulWidget {
  final User user;

  const Body({required this.user});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  late User _currentUser;
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  late Animation animation;
  late AnimationController animationController;
  late Animation animation2;
  late AnimationController animationController2;
  late Animation animation3;
  late AnimationController animationController3;
  late Animation animation4;
  late AnimationController animationController4;
  late Animation animation5;
  late AnimationController animationController5;
  late Animation animation6;
  late AnimationController animationController6;
  FocusNode? pin1FocusNode;
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;
  double size1 = 0.0;
  double size2 = 0.0;
  double size3 = 0.0;
  double size4 = 0.0;
  double smallCircle = 15.0;
  bool resend = false;
  Color? wrongColor;
  CountDownController _controller = CountDownController();
  int _duration = 60;

  @override
  void initState() {
    _currentUser = widget.user;
    sendOtp();
    //userVerify(_currentUser);
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation = Tween(begin: 0.0, end: 75.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    animationController2 =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);
    CurvedAnimation curve2 =
        CurvedAnimation(parent: animationController2, curve: Curves.easeOut);

    animation2 = Tween(begin: 0.0, end: 75.0).animate(curve2)
      ..addListener(() {
        setState(() {});
      });
    animationController3 =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);
    CurvedAnimation curve3 =
        CurvedAnimation(parent: animationController3, curve: Curves.easeOut);

    animation3 = Tween(begin: 0.0, end: 75.0).animate(curve3)
      ..addListener(() {
        setState(() {});
      });
    animationController4 =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);
    CurvedAnimation curve4 =
        CurvedAnimation(parent: animationController4, curve: Curves.easeOut);

    animation4 = Tween(begin: 0.0, end: 75.0).animate(curve4)
      ..addListener(() {
        setState(() {});
      });
    animationController5 =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);
    CurvedAnimation curve5 =
        CurvedAnimation(parent: animationController5, curve: Curves.easeOut);

    animation5 = Tween(begin: 0.0, end: 75.0).animate(curve5)
      ..addListener(() {
        setState(() {});
      });

    animationController6 =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);
    CurvedAnimation curve6 =
        CurvedAnimation(parent: animationController6, curve: Curves.easeOut);

    animation6 = Tween(begin: 0.0, end: 75.0).animate(curve6)
      ..addListener(() {
        setState(() {});
      });
    pin1FocusNode = FocusNode();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    animationController.dispose();
    animationController2.dispose();
    animationController4.dispose();
    animationController3.dispose();
    animationController5.dispose();
    animationController6.dispose();

    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
  }

  void nextField(
      {required String value,
      FocusNode? focusNodeNext,
      FocusNode? focusNodeBack,
      AnimationController? animationController,
      AnimationController? animationControllerBack}) {
    if (value.length == 1 && currentText.length < 6) {
      currentText += value;
    } else if (value.length == 0 && currentText.length >= 1) {
      currentText = currentText.substring(0, currentText.length - 1);
    }
    print("$currentText");
    if (value.length == 1) {
      animationController!.forward();
      animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        }
      });
    }

    if (value.length == 1 && focusNodeNext != null) {
      focusNodeNext.requestFocus();
    } else if (value.length == 0 && focusNodeBack != null) {
      animationControllerBack!.forward();
      animationControllerBack.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationControllerBack.reverse();
        }
      });
      focusNodeBack.requestFocus();
    }
  }

  EmailAuth emailAuth = EmailAuth(sessionName: "Digitech OTP");

  void sendOtp() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: _currentUser.email.toString(), otpLength: 6);
    if (result) {
      print("send OTP");
    } else {
      print("nooot send OTP");
    }
  }

  void verifyOTP() async {
    bool result = emailAuth.validateOtp(
        recipientMail: _currentUser.email.toString(), userOtp: currentText);

    if (result) {
      print("verified OTP");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => VerifiedScreen(user: _currentUser),
        ),
      );
    } else {
      wrongOTP();
      Fluttertoast.showToast(
        msg: "Wrong OTP.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
      );
      ;
    }
  }

  void wrongOTP() {
    setState(() {
      pin1FocusNode!.requestFocus();
      wrongColor = Colors.red;
      currentText = "";
    });
  }

  /*Future<void> userVerify(User user)async {
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    users.add({'verified': true, 'uid':user.uid});
    return;
  }*/

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
      bottomNavigationBar: buildTimer(),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                Text(
                  "We've sent a verification code to ${_currentUser.email!.substring(0,5)}******",
                  style: headingStyle,
                ),
                Form(
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
                                    shape: BoxShape.circle,
                                    color: kPrimaryColor),
                                width: animation.value,
                                height: animation.value,
                                child: TextFormField(
                                  enableInteractiveSelection: false,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
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
                                    wrongColor = null;
                                    nextField(
                                        value: value,
                                        focusNodeNext: pin2FocusNode,
                                        animationController:
                                            animationController);
                                  },
                                ),
                              ),
                              Container(
                                height: animation.value > 0 ? 0.0 : smallCircle,
                                width: animation.value > 0 ? 0.0 : smallCircle,
                                decoration: BoxDecoration(
                                  color: wrongColor == null
                                      ? lightColor
                                      : wrongColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(60)),
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
                                    color: kPrimaryColor),
                                width: animation2.value > 0
                                    ? animation2.value
                                    : 0.0,
                                height: animation2.value > 0
                                    ? animation2.value
                                    : 0.0,
                                child: TextFormField(
                                  enableInteractiveSelection: false,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
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
                                    nextField(
                                        value: value,
                                        focusNodeNext: pin3FocusNode,
                                        focusNodeBack: pin1FocusNode,
                                        animationController:
                                            animationController2,
                                        animationControllerBack:
                                            animationController);
                                  },
                                ),
                              ),
                              Container(
                                height:
                                    animation2.value > 0 ? 0.0 : smallCircle,
                                width: animation2.value > 0 ? 0.0 : smallCircle,
                                decoration: BoxDecoration(
                                  color: wrongColor == null
                                      ? lightColor
                                      : wrongColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(60)),
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
                                    color: kPrimaryColor),
                                width: animation3.value > 0
                                    ? animation3.value
                                    : smallCircle,
                                height: animation3.value > 0
                                    ? animation3.value
                                    : smallCircle,
                                child: TextFormField(
                                  enableInteractiveSelection: false,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
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
                                    nextField(
                                        value: value,
                                        focusNodeNext: pin4FocusNode,
                                        focusNodeBack: pin2FocusNode,
                                        animationController:
                                            animationController3,
                                        animationControllerBack:
                                            animationController2);
                                  },
                                ),
                              ),
                              Container(
                                height:
                                    animation3.value > 0 ? 0.0 : smallCircle,
                                width: animation3.value > 0 ? 0.0 : smallCircle,
                                decoration: BoxDecoration(
                                  color: wrongColor == null
                                      ? lightColor
                                      : wrongColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(60)),
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
                                    color: kPrimaryColor),
                                width: animation4.value > 0
                                    ? animation4.value
                                    : smallCircle,
                                height: animation4.value > 0
                                    ? animation4.value
                                    : smallCircle,
                                child: TextFormField(
                                  enableInteractiveSelection: false,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
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
                                    nextField(
                                        value: value,
                                        focusNodeNext: pin5FocusNode,
                                        focusNodeBack: pin3FocusNode,
                                        animationController:
                                            animationController4,
                                        animationControllerBack:
                                            animationController3);
                                  },
                                ),
                              ),
                              Container(
                                height:
                                    animation4.value > 0 ? 0.0 : smallCircle,
                                width: animation4.value > 0 ? 0.0 : smallCircle,
                                decoration: BoxDecoration(
                                  color: wrongColor == null
                                      ? lightColor
                                      : wrongColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(60)),
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
                                    color: kPrimaryColor),
                                width: animation5.value > 0
                                    ? animation5.value
                                    : smallCircle,
                                height: animation5.value > 0
                                    ? animation5.value
                                    : smallCircle,
                                child: TextFormField(
                                  enableInteractiveSelection: false,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  focusNode: pin5FocusNode,
                                  showCursor: false,
                                  style: TextStyle(
                                      fontSize: 32,
                                      color: kPrimaryLightColor,
                                      fontWeight: FontWeight.w900),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: otpInputDecoration,
                                  onChanged: (value) {
                                    nextField(
                                        value: value,
                                        focusNodeNext: pin6FocusNode,
                                        focusNodeBack: pin4FocusNode,
                                        animationController:
                                            animationController5,
                                        animationControllerBack:
                                            animationController4);
                                  },
                                ),
                              ),
                              Container(
                                height:
                                    animation5.value > 0 ? 0.0 : smallCircle,
                                width: animation5.value > 0 ? 0.0 : smallCircle,
                                decoration: BoxDecoration(
                                  color: wrongColor == null
                                      ? lightColor
                                      : wrongColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(60)),
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
                                    color: kPrimaryColor),
                                width: animation6.value > 0
                                    ? animation6.value
                                    : smallCircle,
                                height: animation6.value > 0
                                    ? animation6.value
                                    : smallCircle,
                                child: TextFormField(
                                  enableInteractiveSelection: false,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  focusNode: pin6FocusNode,
                                  showCursor: false,
                                  style: TextStyle(
                                      fontSize: 32,
                                      color: kPrimaryLightColor,
                                      fontWeight: FontWeight.w900),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: otpInputDecoration,
                                  onChanged: (value) {
                                    nextField(
                                        value: value,
                                        focusNodeBack: pin5FocusNode,
                                        animationController:
                                            animationController6,
                                        animationControllerBack:
                                            animationController5);
                                    verifyOTP();
                                  },
                                ),
                              ),
                              Container(
                                height:
                                    animation6.value > 0 ? 0.0 : smallCircle,
                                width: animation6.value > 0 ? 0.0 : smallCircle,
                                decoration: BoxDecoration(
                                  color: wrongColor == null
                                      ? lightColor
                                      : wrongColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(60)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.15),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.1),
              ],
            ),
          ),
        ),
      ),
    ));

  }

  buildTimer() {

    return Padding(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
                child: CircularCountDownTimer(
              // Countdown duration in Seconds.
              duration: _duration,

              // Countdown initial elapsed Duration in Seconds.
              initialDuration: 0,

              // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
              controller: _controller,

              // Width of the Countdown Widget.
              width: 30,

              // Height of the Countdown Widget.
              height: 30,

              // Ring Color for Countdown Widget.
              ringColor: lightColor,

              // Ring Gradient for Countdown Widget.
              ringGradient: null,

              // Filling Color for Countdown Widget.
              fillColor: kPrimaryColor,

              // Filling Gradient for Countdown Widget.
              fillGradient: null,

              // Background Color for Countdown Widget.
              backgroundColor: kPrimaryLightColor,

              // Background Gradient for Countdown Widget.
              backgroundGradient: null,

              // Border Thickness of the Countdown Ring.
              strokeWidth: 5.0,

              // Begin and end contours with a flat edge and no extension.
              strokeCap: StrokeCap.round,

              // Text Style for Countdown Text.
              textStyle: TextStyle(
                  fontSize: 15.0,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold),

              // Format for the Countdown Text.
              textFormat: CountdownTextFormat.S,

              // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
              isReverse: true,

              // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
              isReverseAnimation: true,

              // Handles visibility of the Countdown Text.
              isTimerTextShown: true,

              // Handles the timer start.
              autoStart: true,

              // This Callback will execute when the Countdown Starts.
              onStart: () {
                // Here, do whatever you want
                print('Countdown Started');
              },

              // This Callback will execute when the Countdown Ends.
              onComplete: () {
                // Here, do whatever you want
                setState(() {
                  resend = true;
                });

                print('Countdown Ended');
              },
            )),
            Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Didn't receive OTP yet?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    resend
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                sendOtp();
                                pin1FocusNode!.requestFocus();
                                currentText = "";
                                _controller.restart();
                                resend = false;
                              });
                            },
                            child: Text(
                              "Resend",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        : Text(
                            "Resend",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: kSecondaryLightColor),
                          )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
