import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stedfasts_scheduler/screens/2.signin_screen/signin_screen.dart';
import 'package:stedfasts_scheduler/utilities/constants.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> indicatorList = [];
    for (int i = 0; i < _numPages; i++) {
      indicatorList
          .add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return indicatorList;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 12.0,
      width: isActive ? 12.0 : 12.0,
      decoration: BoxDecoration(
          color: isActive ? Color(0xFF4D3385) : Color(0xFFB593FB),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 600.0,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Column(
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/onboarding1.png',
                                width: 450,
                                height: 400,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              "Check your daily schedule",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  textStyle: kOnboardingTextStyle),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Column(
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/onboarding2.png',
                                width: 450,
                                height: 400,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              "Punch In your Daily Start time",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  textStyle: kOnboardingTextStyle),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Column(
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/onboarding3.png',
                                width: 450,
                                height: 400,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              "Make sure to punch your Lunch time",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  textStyle: kOnboardingTextStyle),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Column(
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/onboarding4.png',
                                width: 450,
                                height: 450,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              "Drive safe!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  textStyle: kOnboardingTextStyle),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                SizedBox(height: 30.0),
                _currentPage != _numPages - 1
                    ? Row(
                        children: [
                          _skipButton(),
                          Expanded(
                            child: Align(
                              alignment: FractionalOffset.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  _pageController.nextPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut);
                                },
                                child: Container(
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xff714AC3),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_right,
                                    color: Colors.white,
                                    size: 60.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Expanded(
                        child: Align(
                            alignment: FractionalOffset.bottomRight,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: 15.0, right: 15.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SigninScreen.create(context),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.montserrat(
                                    color: Color(0xff714AC3),
                                    fontSize: 32.0,
                                    textStyle: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            )),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned _skipButton() {
    return Positioned(
      // alignment: Alignment.bottomLeft,
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SigninScreen.create(context),
            ),
          );
        },
        child: Text(
          "Skip",
          style: GoogleFonts.montserratAlternates(
              color: Colors.black, fontSize: 18.0),
        ),
      ),
    );
  }
}
