import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stedfasts_scheduler/models/schedule_model.dart';
import 'package:stedfasts_scheduler/services/schedule_database.dart';
import 'package:stedfasts_scheduler/utilities/custom_flat_button.dart';
import 'package:stedfasts_scheduler/utilities/display_time.dart';
import 'package:timer_builder/timer_builder.dart';

class BuildTodayScreenPanel extends StatefulWidget {
  BuildTodayScreenPanel({@required this.schedule});
  final DaySchedule schedule;

  @override
  _BuildTodayScreenPanelState createState() => _BuildTodayScreenPanelState();
}

class _BuildTodayScreenPanelState extends State<BuildTodayScreenPanel> {
  DaySchedule get schedule => widget.schedule;
  // bool hasLoggedIn;
  DateTime currentLoginTime;
  DateTime lunchTime;
  DateTime currentLunchTime;
  DateTime lunchFinishTime;
  DateTime currentLunchFinishTime;
  DateTime logoutTime;
  DateTime currentLogoutTime;
  String shiftLogin;
  String shiftLunchStart;
  String shiftLunchfinish;
  String shiftLogout;
  int shiftStart;

  @override
  void initState() {
    super.initState();
    // hasLoggedIn = schedule.loginTime != null ? true : false;
    shiftStart = _getShiftHours();

    lunchTime = schedule.loginTime != null
        ? schedule.loginTime.add(Duration(seconds: 10))
        : null;
    lunchFinishTime = schedule.lunchTime != null
        ? schedule.lunchTime.add(Duration(seconds: 10))
        : null;

    currentLunchTime = schedule.lunchTime != null ? schedule.lunchTime : null;
    logoutTime = schedule.loginTime != null
        ? schedule.loginTime.add(Duration(seconds: 30))
        : null;
    shiftLogin = schedule.loginTime != null
        ? DateFormat.jm().format(schedule.loginTime)
        : null;
    shiftLunchStart = schedule.lunchTime != null
        ? DateFormat.jm().format(schedule.lunchTime)
        : null;
    shiftLunchfinish = schedule.lunchFinishTime != null
        ? DateFormat.jm().format(schedule.lunchTime)
        : null;
    shiftLogout = schedule.logoutTime != null
        ? DateFormat.jm().format(schedule.logoutTime)
        : null;
  }

  int _getShiftHours() {
    switch (schedule.shiftHours) {
      case 10:
        {
          return 8;
        }
        break;
      case 8:
        {
          return 12;
        }
        break;
      case 5:
        {
          return 5;
        }
        break;
      default:
        {
          return 0;
        }
    }
  }

  get scheduleDatabase => Provider.of<ScheduleDatabase>(context, listen: false);

  void todayLogin() async {
    DaySchedule todayLogin = DaySchedule(
      id: schedule.id,
      driverId: schedule.driverId,
      driverName: schedule.driverName,
      shiftDate: schedule.shiftDate,
      shiftHours: schedule.shiftHours,
      shiftType: schedule.shiftType,
      weekNumber: schedule.weekNumber,
      loginTime: DateTime.now(),
      lunchTime: null,
      lunchFinishTime: null,
      logoutTime: null,
      eod: false,
    );

    await scheduleDatabase.setNewSchedule(todayLogin);
    setState(() {
      currentLoginTime = schedule.loginTime;
      shiftLogin = DateFormat.jm().format(schedule.loginTime);
      lunchTime = schedule.loginTime.add(Duration(seconds: 10));
      logoutTime = schedule.loginTime.add(Duration(seconds: 30));
    });
  }

  void todayLunch() async {
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
      lunchFinishTime: null,
      logoutTime: null,
      eod: false,
    );
    await scheduleDatabase.setNewSchedule(todayLunchLogin);
    setState(() {
      currentLunchTime = schedule.lunchTime;
      lunchFinishTime = schedule.lunchTime.add(Duration(seconds: 10));
      shiftLunchStart = DateFormat.jm().format(schedule.lunchTime);
    });
  }

  void todayFinishLunch() async {
    DaySchedule todayFinishLunchLogin = DaySchedule(
      id: schedule.id,
      driverId: schedule.driverId,
      driverName: schedule.driverName,
      shiftDate: schedule.shiftDate,
      shiftHours: schedule.shiftHours,
      shiftType: schedule.shiftType,
      weekNumber: schedule.weekNumber,
      loginTime: schedule.loginTime,
      lunchTime: schedule.lunchTime,
      lunchFinishTime: DateTime.now(),
      logoutTime: null,
      eod: false,
    );
    await scheduleDatabase.setNewSchedule(todayFinishLunchLogin);
    setState(() {
      currentLunchFinishTime = schedule.lunchFinishTime;
      lunchFinishTime = currentLunchFinishTime.add(Duration(seconds: 5));
      shiftLunchfinish = DateFormat.jm().format(schedule.lunchTime);
    });
  }

  void todayLogout() async {
    DaySchedule todayLunchLogin = DaySchedule(
      id: schedule.id,
      driverId: schedule.driverId,
      driverName: schedule.driverName,
      shiftDate: schedule.shiftDate,
      shiftHours: schedule.shiftHours,
      shiftType: schedule.shiftType,
      weekNumber: schedule.weekNumber,
      loginTime: schedule.loginTime,
      lunchTime: schedule.lunchTime,
      lunchFinishTime: schedule.lunchFinishTime,
      logoutTime: DateTime.now(),
      eod: true,
    );
    await scheduleDatabase.setNewSchedule(todayLunchLogin);
    setState(() {
      shiftLogout = DateFormat.jm().format(schedule.logoutTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(logoutTime);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Image.asset('assets/images/today/panel_slider.png'),
          ShowShiftStartTime(shiftstart: shiftStart),
          SizedBox(
            height: 10.0,
          ),
          shiftLogin == null
              ? CustomFlatButton(
                  label: "Login",
                  onPressed: todayLogin,
                )
              : DisplayTime(
                  label: "Login",
                  content: " $shiftLogin",
                ),
          lunchTime != null && shiftLunchStart == null
              ? buildTimer(
                  startTime: schedule.loginTime,
                  endTime: lunchTime,
                  buttonLabel: "Lunch",
                  buttonPressFunction: todayLunch,
                  dur: 10,
                )
              : Text(''),
          SizedBox(
            height: 30.0,
          ),
          shiftLunchStart != null
              ? DisplayTime(
                  label: "Lunch",
                  content: " $shiftLunchStart",
                )
              : Text(''),
          lunchFinishTime != null && shiftLunchfinish == null
              ? buildTimer(
                  startTime: currentLunchTime,
                  endTime: lunchFinishTime,
                  buttonLabel: "Finish Lunch",
                  buttonPressFunction: todayFinishLunch,
                  dur: 10,
                )
              : Text(''),
          shiftLunchfinish != null
              ? DisplayTime(
                  label: "Lunch \nFinish",
                  content: "$shiftLunchfinish",
                )
              : Text(''),
          shiftLunchfinish != null && logoutTime != null && shiftLogout == null
              ? buildTimer(
                  startTime: currentLunchFinishTime,
                  endTime: logoutTime,
                  buttonLabel: "Logout",
                  buttonPressFunction: todayLogout,
                  dur: 15,
                )
              : Text(''),
          shiftLogout != null
              ? DisplayTime(
                  label: "Logout",
                  content: shiftLogout,
                )
              : Text(''),
        ],
      ),
    );
  }

  buildTimer(
      {DateTime startTime,
      DateTime endTime,
      String buttonLabel,
      VoidCallback buttonPressFunction,
      int dur}) {
    return TimerBuilder.scheduled([startTime, endTime], builder: (context) {
      final now = DateTime.now();
      final started = now.compareTo(startTime) >= 0;
      final ended = now.compareTo(endTime) >= 0;
      return started
          ? ended
              ? CustomFlatButton(
                  label: buttonLabel,
                  onPressed: buttonPressFunction,
                )
              : startTimer(dur)
          : Text("Not Started");
    });
  }

  startTimer(int dur) {
    return CircularCountDownTimer(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 4,
      duration: dur,
      fillColor: Colors.red,
      color: Colors.white,
      strokeWidth: 5.0,
    );
  }
}

class ShowShiftStartTime extends StatelessWidget {
  const ShowShiftStartTime({
    Key key,
    @required this.shiftstart,
  }) : super(key: key);

  final int shiftstart;

  @override
  Widget build(BuildContext context) {
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
}
