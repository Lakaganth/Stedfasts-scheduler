import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stedfasts_scheduler/models/schedule_model.dart';
import 'package:stedfasts_scheduler/services/auth.dart';
import 'package:stedfasts_scheduler/services/schedule_database.dart';
import 'package:timer_builder/timer_builder.dart';

class TodayScreen extends StatefulWidget {
  TodayScreen({@required this.user});

  final User user;

  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  User get user => widget.user;
  bool hasLoggedIn = false;
  bool finishedLunch = false;
  DateTime currentLoginTime;

  BorderRadius _panelRadius = BorderRadius.only(
      topLeft: Radius.circular(35.0), topRight: Radius.circular(35.0));

  get screenWidth => MediaQuery.of(context).size.width;
  get screenHeight => MediaQuery.of(context).size.height;

  DateTime _todayDateTime = DateTime.now();
  String get _todayDate => DateFormat('d-MMM-yyyy').format(_todayDateTime);
  String get _todayDayName => DateFormat('EEEE').format(_todayDateTime);

  void _todayLogin(DaySchedule schedule, var onlyTodayDate) async {
    final scheduleDatabase =
        Provider.of<ScheduleDatabase>(context, listen: false);
    // print("Login time ${DateTime.now()} , The id to be changed ${schedule.id}");
    setState(() {
      currentLoginTime = DateTime.now();
      hasLoggedIn = true;
    });
    DaySchedule todayLogin = DaySchedule(
      id: schedule.id,
      driverId: schedule.driverId,
      driverName: schedule.driverName,
      shiftDate: schedule.shiftDate,
      shiftHours: schedule.shiftHours,
      shiftType: schedule.shiftType,
      weekNumber: schedule.weekNumber,
      loginTime: currentLoginTime,
      lunchTime: null,
    );
    await scheduleDatabase.setNewSchedule(todayLogin);
  }

  void _todayLunch(DaySchedule schedule, var onlyTodayDate) async {
    final scheduleDatabase =
        Provider.of<ScheduleDatabase>(context, listen: false);
    DaySchedule todayLunchLogin = DaySchedule(
      id: schedule.id,
      driverId: schedule.driverId,
      driverName: schedule.driverName,
      shiftDate: schedule.shiftDate,
      shiftHours: schedule.shiftHours,
      shiftType: schedule.shiftType,
      weekNumber: schedule.weekNumber,
      loginTime: schedule.loginTime,
      lunchTime: DateTime.now(),
      eod: true,
    );
    await scheduleDatabase.setNewSchedule(todayLunchLogin);
    setState(() {
      finishedLunch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScheduleDatabase schedule = Provider.of<ScheduleDatabase>(context);
    final AuthBase auth = Provider.of<AuthBase>(context);
    return StreamBuilder(
      stream: schedule.weeksHoursStream(widget.user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          List<DaySchedule> items = snapshot.data;

          List<DaySchedule> todaySchedule = items.where((e) {
            var onlyTodayDate = DateFormat('d-MM-yyyy').format(_todayDateTime);
            var onlyElementDate = DateFormat('d-MM-yyyy').format(e.shiftDate);

            return onlyTodayDate == onlyElementDate;
          }).toList();

          if (snapshot.hasData) {
            return Scaffold(
              body: SlidingUpPanel(
                backdropEnabled: true,
                borderRadius: _panelRadius,
                body: _buildBody(),
                panel: _buildPanel(todaySchedule[0]),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error , ${snapshot.error}"),
            );
          } else if (todaySchedule.length == 0) {
            return Container(
              child: Text("No Data"),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.warning),
                ),
                Text('Error in loadind data')
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Positioned(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/today/map_bg.png'),
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
            width: screenWidth,
            height: 200.0,
            child: Column(
              children: _buildTodayDate(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPanel(DaySchedule schedule) {
    // print(schedule.shiftHours);

    int shiftStart;
    String shiftLogin = schedule.loginTime != null
        ? DateFormat.jm().format(schedule.loginTime)
        : null;
    DateTime shiftToLunch = schedule.loginTime != null
        ? schedule.loginTime.add(Duration(seconds: 10))
        : null;
    String shiftLunch = schedule.lunchTime != null
        ? DateFormat.jm().format(schedule.lunchTime)
        : null;

    switch (schedule.shiftHours) {
      case 10:
        {
          shiftStart = 8;
        }
        break;
      case 8:
        {
          shiftStart = 12;
        }
        break;
      case 6:
        {
          shiftStart = 6;
        }
        break;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Image.asset('assets/images/today/panel_slider.png'),
          _shiftStartTime(shiftStart),
          SizedBox(
            height: 30.0,
          ),
          // _buildLoginButton(schedule),
          SizedBox(
            height: 30.0,
          ),
          shiftLogin == null
              ? _buildLoginButton(schedule)
              : _showShiftLogin(shiftLogin),
          shiftToLunch != null && shiftLunch == null
              ? _buildTimers(shiftToLunch, schedule)
              : Text(''),
          SizedBox(
            height: 30.0,
          ),
          shiftLunch != null ? _showLunchLogin(shiftLunch) : Text(''),
        ],
      ),
    );
  }

  List<Widget> _buildTodayDate() {
    String _todayDay = _todayDate.split('-')[0];
    String _todayMonth = _todayDate.split('-')[1];
    String _todayYear = _todayDate.split('-')[2];

    return [
      SizedBox(
        height: 20.0,
      ),
      Text(
        "$_todayDay $_todayMonth",
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
    ];
  }

  Widget _shiftStartTime(int shiftstart) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Text(
            "Shift \nStart",
            style: GoogleFonts.metrophobic(
              fontSize: 28.0,
              color: Color(0xff646464),
            ),
          ),
          SizedBox(
            width: 50.0,
          ),
          Text(
            "$shiftstart:00",
            style: GoogleFonts.montserrat(fontSize: 54.0),
          ),
          shiftstart == 8
              ? Text(
                  "AM",
                  style: GoogleFonts.montserrat(
                    fontSize: 32.0,
                  ),
                )
              : Text(
                  "PM",
                  style: GoogleFonts.montserrat(
                    fontSize: 32.0,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(DaySchedule schedule) {
    return Container(
      height: 50,
      width: screenWidth / 1.3,
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
        onPressed:
            !hasLoggedIn ? () => _todayLogin(schedule, _todayDate) : null,
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
    );
  }

  Widget _showShiftLogin(shiftLogin) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Text(
            "Login",
            style: GoogleFonts.metrophobic(
              fontSize: 28.0,
              color: Color(0xff646464),
            ),
          ),
          SizedBox(
            width: 60.0,
          ),
          Text(
            "$shiftLogin",
            style: GoogleFonts.montserrat(fontSize: 42.0),
          ),
        ],
      ),
    );
  }

  _buildTimers(DateTime shiftToLunch, DaySchedule schedule) {
    return TimerBuilder.scheduled([schedule.loginTime, shiftToLunch],
        builder: (context) {
      final now = DateTime.now();
      final started = now.compareTo(schedule.loginTime) >= 0;
      final ended = now.compareTo(shiftToLunch) >= 0;
      return started
          ? ended ? _showLunchButton(schedule) : _startTimer(shiftToLunch)
          : Text("Not Started");
    });
  }

  _showLunchButton(DaySchedule schedule) {
    return Container(
      height: 50,
      width: screenWidth / 1.3,
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
        onPressed: hasLoggedIn ? () => _todayLunch(schedule, _todayDate) : null,
        child: Center(
          child: Text(
            "Lunch",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.0),
          ),
        ),
      ),
    );
  }

  _startTimer(shiftToLunch) {
    return Center(
      child: CircularCountDownTimer(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 3,
        duration: 10,
        fillColor: Colors.red,
        color: Colors.white,
        strokeWidth: 5.0,
      ),
    );
  }

  _showLunchLogin(shiftLunch) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Text(
            "Lunch",
            style: GoogleFonts.metrophobic(
              fontSize: 28.0,
              color: Color(0xff646464),
            ),
          ),
          SizedBox(
            width: 50.0,
          ),
          Text(
            "$shiftLunch",
            style: GoogleFonts.montserrat(fontSize: 42.0),
          ),
        ],
      ),
    );
  }
}
