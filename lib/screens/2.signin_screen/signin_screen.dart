import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stedfasts_scheduler/common/platform_exception_alert_dialog.dart';
import 'package:stedfasts_scheduler/screens/2.signin_screen/reset_password_confirm_email.dart';
import 'package:stedfasts_scheduler/screens/2.signin_screen/signin_viewmodel.dart';
import 'package:stedfasts_scheduler/services/auth.dart';
import 'package:stedfasts_scheduler/utilities/fade_animation.dart';

class SigninScreen extends StatefulWidget {
  final SigninModel model;
  SigninScreen({@required this.model});

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider(
      create: (context) => SigninModel(auth: auth),
      child: Consumer<SigninModel>(
        builder: (context, model, _) => SigninScreen(
          model: model,
        ),
      ),
    );
  }

  @override
  _SigninScreen createState() => _SigninScreen();
}

class _SigninScreen extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  get screenWidth => MediaQuery.of(context).size.width;
  get screenHeight => MediaQuery.of(context).size.height;

  SigninModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(title: 'Sign In Failed', exception: e)
          .show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // height: screenHeight - 100,
          child: Column(
            children: [
              Container(
                height: 400,
                margin: EdgeInsets.only(top: 22.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/signin/purplebg.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                child: buildAnimationStack(),
              ),
              SizedBox(
                height: 20.0,
              ),
              buildInputFields()
            ],
          ),
        ),
      ),
    );
  }

  Stack buildAnimationStack() {
    return Stack(
      children: [
        Positioned(
          top: -10,
          left: 20,
          width: 80,
          height: 200,
          child: FadeAnimation(
            1,
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/signin/lampfore.png'),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: -30,
          left: 120,
          width: 80,
          height: 200,
          child: FadeAnimation(
            1.3,
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/signin/lampback.png'),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: -30,
          right: 30,
          width: 80,
          height: 200,
          child: FadeAnimation(
            1.5,
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/signin/clock.png'),
                ),
              ),
            ),
          ),
        ),
        // Positioned(
        //   top: 30,

        //   child: Container(
        //     child: Center(
        //       child: Text(
        //         "Login",
        //         textAlign: TextAlign.center,
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 40,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Positioned(
          top: 200.0,
          child: FadeAnimation(
            1.6,
            Container(
              width: 380,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/signin/signin_hero.png'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding buildInputFields() {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: [
          FadeAnimation(
            1.8,
            Container(
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
                            bottom: BorderSide(color: Colors.grey[100]))),
                    child: _buildEmailTextField(),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: _buildPasswordTextField(),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          buildLoginButton(),
          SizedBox(
            height: 20,
          ),
          FadeAnimation(
            1.5,
            FlatButton(
              onPressed: () => ResetPasswordConfirmEmail.create(context),
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Color.fromRGBO(143, 148, 251, 1),
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Password",
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: model.updatePassword,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Email or Phone number",
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      onChanged: model.updateEmail,
    );
  }

  FadeAnimation buildLoginButton() {
    return FadeAnimation(
      2,
      Container(
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
          onPressed: model.canSubmit ? _submit : null,
          child: Center(
            child: Text(
              "Login",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
          ),
        ),
      ),
    );
  }
}
