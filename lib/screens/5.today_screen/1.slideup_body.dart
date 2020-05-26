import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BuildTodaySlideupScreenBody extends StatelessWidget {
  final String _todayDate = DateFormat('d-MM-yyyy').format(DateTime.now());

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
            width: (MediaQuery.of(context).size.width),
            height: 200.0,
            child: Column(
              children: _buildTodayDate(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTodayDate() {
    String _todayDay = _todayDate.split('-')[0];
    String _todayMonth = _todayDate.split('-')[1];
    String _todayYear = _todayDate.split('-')[2];
    String _todayDayName = DateFormat('EEEE').format(DateTime.now());

    const monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return [
      SizedBox(
        height: 10.0,
      ),
      Text(
        "$_todayDay ${monthNames[DateTime.now().month + 1]}",
        style: GoogleFonts.montserrat(
          fontSize: 54.0,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 10.8,
        ),
      ),
      Text(
        "$_todayYear",
        style: GoogleFonts.montserrat(
          fontSize: 44.0,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 10.8,
        ),
      ),
      Text(
        "$_todayDayName",
        style: GoogleFonts.montserrat(
          fontSize: 32.0,
          color: Colors.white,
          fontWeight: FontWeight.w100,
          letterSpacing: 10.8,
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
    ];
  }
}
