import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stedfasts_scheduler/common/platform_alert_dialog.dart';
import 'package:stedfasts_scheduler/common/platform_exception_alert_dialog.dart';
import 'package:stedfasts_scheduler/services/auth.dart';
import 'package:stedfasts_scheduler/utilities/fade_animation.dart';
import 'package:stedfasts_scheduler/utilities/form_submit_button.dart';

class ResetPasswordConfirmEmail extends StatefulWidget {
  static void create(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ResetPasswordConfirmEmail(),
      fullscreenDialog: true,
    ));
  }

  @override
  _ResetPasswordConfirmEmailState createState() =>
      _ResetPasswordConfirmEmailState();
}

class _ResetPasswordConfirmEmailState extends State<ResetPasswordConfirmEmail> {
  String email;

  get screenWidth => MediaQuery.of(context).size.width;
  get screenHeight => MediaQuery.of(context).size.height;

  void initState() {
    super.initState();

    // _emailController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _confirmEmail() async {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.sendResetPasswordEmail(email);
      await PlatformAlertDialog(
              title: "Reset Password",
              content:
                  "Email Sent to $email, foloow the instructions in the email to reset password",
              defaultActionsText: "Confirm")
          .show(context);
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(title: "Reset Failed", exception: e)
          .show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              ClipPath(
                clipper: BackgroundClipper(screenHeight / 1.2),
                child: FadeAnimation(
                  0.5,
                  Container(
                    height: screenHeight / 1.2,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(98, 41, 253, .63),
                          Color.fromRGBO(228, 170, 255, .33),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, .3),
                          blurRadius: 20.0,
                          offset: Offset(5, 12),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Align(
                              alignment: FractionalOffset.topRight,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/signin/reset_hero.png"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(229, 216, 253, 1),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[100]))),
                                  child: _buildEmailTextField(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Confirm Email",
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onChanged: (value) {
        setState(() {
          email = value;
        });
      },
    );
  }

  FadeAnimation buildLoginButton() {
    return FadeAnimation(
      1,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(98, 41, 253, .63),
                Color.fromRGBO(228, 170, 255, .33),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(143, 148, 251, .3),
                blurRadius: 20.0,
                offset: Offset(5, 12),
              )
            ],
          ),
          child: FlatButton(
            onPressed: _confirmEmail,
            child: Center(
              child: Text(
                "Reset",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 24.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  final double height;

  BackgroundClipper(this.height);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, height - 200);
    path.quadraticBezierTo(
      size.width / 2,
      height,
      size.width,
      height - 200,
    );
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
