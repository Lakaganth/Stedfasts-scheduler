import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stedfasts_scheduler/screens/1.welcome_screen/welcome_screen.dart';
import 'package:stedfasts_scheduler/screens/4.home_screen/home_screen.dart';
import 'package:stedfasts_scheduler/services/auth.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;

          if (user == null) {
            return WelcomeScreen();
          } else {
            return HomeScreen(
              user: user,
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
