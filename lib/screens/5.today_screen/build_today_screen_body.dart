import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BuildTodayScreenBody extends StatelessWidget {
  BuildTodayScreenBody({@required this.todayDateTime});

  final DateTime todayDateTime;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/today/map_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 100.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, .5),
                  blurRadius: 20.0,
                  offset: Offset(5, 12),
                )
              ],
              color: Color.fromRGBO(29, 28, 29, 1),
            ),
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            child: Column(
              children: buildTodayDate(false, todayDateTime),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildTodayDate(bool noShift, DateTime todayDateTime) {
    String _todayDate = DateFormat('d-MMM-yyyy').format(todayDateTime);
    String _todayDayName = DateFormat('EEEE').format(todayDateTime);

    String _todayDay = _todayDate.split('-')[0];
    String _todayMonth = _todayDate.split('-')[1];
    String _todayYear = _todayDate.split('-')[2];

    return [
      SizedBox(
        height: 10.0,
      ),
      Text(
        "$_todayDay $_todayMonth",
        style: GoogleFonts.montserrat(
          fontSize: !noShift ? 54.0 : 32.0,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 10.8,
        ),
      ),
      Text(
        "$_todayYear",
        style: GoogleFonts.montserrat(
          fontSize: !noShift ? 44.0 : 24.0,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 10.8,
        ),
      ),
      Text(
        "$_todayDayName",
        style: GoogleFonts.montserrat(
          fontSize: !noShift ? 32.0 : 20.0,
          color: Colors.white,
          fontWeight: FontWeight.w100,
          letterSpacing: 10.8,
        ),
      ),
      SizedBox(
        height: noShift ? 20.0 : 0.0,
      ),
      noShift
          ? Text(
              "No shift today, Check schedule for next shift",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.w300,
                // letterSpacing: 10.8,
              ),
            )
          : Text('')
    ];
  }
}
