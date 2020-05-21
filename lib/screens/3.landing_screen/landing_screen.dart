import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stedfasts_scheduler/screens/1.welcome_screen/onboarding_screen.dart';
import 'package:stedfasts_scheduler/screens/1.welcome_screen/welcome_screen.dart';
import 'package:stedfasts_scheduler/screens/4.home_screen/home_screen.dart';
import 'package:stedfasts_scheduler/screens/8.admin_driver_list/admin_driver_list_screen.dart';
import 'package:stedfasts_scheduler/services/auth.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return OnboardingScreen();
          }
          if (user.uid == "a0KyfBuApiOcdtMhD5HcWCzr3h33") {
            return AdminDriverListScreen();
            // return Faker();
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
