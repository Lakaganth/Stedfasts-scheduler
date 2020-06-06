import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayTime extends StatelessWidget {
  final String label;
  final String content;

  DisplayTime({
    @required this.label,
    @required this.content,
  });

  @override
  Padding build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Text(
            "$label",
            style: GoogleFonts.metrophobic(
              fontSize: 28.0,
              color: Color(0xff646464),
            ),
          ),
          SizedBox(
            width: 60.0,
          ),
          Text(
            "$content",
            style: GoogleFonts.montserrat(fontSize: 42.0),
          ),
        ],
      ),
    );
  }
}
