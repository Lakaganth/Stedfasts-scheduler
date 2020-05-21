import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stedfasts_scheduler/screens/1.welcome_screen/onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "STEDFASTS",
              style: GoogleFonts.cinzel(
                color: Colors.black,
                fontSize: 52.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Text(
              "Scheduler \n App",
              textAlign: TextAlign.center,
              style: GoogleFonts.bitter(color: Colors.grey, fontSize: 32.0),
            ),
            SizedBox(
              height: 150.0,
            ),
            Container(
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13.0),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(95, 112, 200, 1),
                      Color.fromRGBO(63, 82, 186, .37),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, .2),
                        blurRadius: 20.0,
                        offset: Offset(5, 5))
                  ]),
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OnboardingScreen(),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    "Welcome",
                    style: GoogleFonts.montserrat(
                        color: Colors.white, fontSize: 24.0),
                  ),
                ),
              ),
            ),

            // Stack(
            //   children: [
            //     Positioned(
            //       width: 80.0,
            //       height: 60.0,
            //       // bottom: 2.0,
            //       child: Container(
            //         decoration: BoxDecoration(
            //           image: DecorationImage(
            //             image: AssetImage('assets/images/welcome_screen.png'),
            //             scale: 0.5,
            //             fit: BoxFit.fill,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
