import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stedfasts_scheduler/screens/3.landing_screen/landing_screen.dart';
import 'package:stedfasts_scheduler/services/auth.dart';
import 'package:stedfasts_scheduler/services/driver_database.dart';
import 'package:stedfasts_scheduler/services/schedule_database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBase>(
          create: (context) => Auth(),
        ),
        Provider<ScheduleDatabase>(
          create: (context) => ScheduleFirestoreDatabase(),
        ),
        Provider<DriverDatabase>(
          create: (context) => DriveFirestoreDatabase(),
        )
      ],
      child: MaterialApp(
        title: "Stedfasts Scheduler App",
        debugShowCheckedModeBanner: false,
        home: LandingScreen(),
      ),
    );
  }
}
