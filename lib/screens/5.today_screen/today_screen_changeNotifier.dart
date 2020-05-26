import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stedfasts_scheduler/models/schedule_model.dart';
import 'package:stedfasts_scheduler/services/schedule_database.dart';

class TodayScreenChangeNotifier with ChangeNotifier {
  bool hasLoggedIn;
  bool finishedLunch;
  bool eodCheck;
  DateTime currentLoginTime;
  DateTime lunchTime;
  DateTime lunchPunchTime;
  DaySchedule schedule;

  TodayScreenChangeNotifier({
    this.hasLoggedIn: false,
    this.finishedLunch: false,
    this.eodCheck,
    this.currentLoginTime,
    this.lunchTime,
    this.lunchPunchTime,
    @required this.schedule,
  });

  void todayLogin({BuildContext context}) async {
    final scheduleDatabase =
        Provider.of<ScheduleDatabase>(context, listen: false);

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
    );
    await scheduleDatabase.setNewSchedule(todayLogin);

    updateWith(
      currentLoginTime: DateTime.now(),
      lunchTime: DateTime.now().add(Duration(seconds: 10)),
      hasLoggedIn: true,
    );
    // _showNotifications();
    // _showLunchReminderNotification();
  }

  void todayLunch({BuildContext context}) async {
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
      loginTime: currentLoginTime,
      lunchTime: DateTime.now(),
      eod: true,
    );
    await scheduleDatabase.setNewSchedule(todayLunchLogin);
    updateWith(
        finishedLunch: true, lunchPunchTime: DateTime.now(), eodCheck: true);
  }

  int getShiftStart() {
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
      case 6:
        {
          return 6;
        }
        break;
    }
  }

  String get getShiftLogin => schedule.loginTime != null
      ? DateFormat.jm().format(schedule.loginTime)
      : null;

  DateTime get getShiftTimetoLunch => schedule.loginTime != null
      ? schedule.loginTime.add(Duration(seconds: 20))
      : null;

  String get getLunchTime => schedule.lunchTime != null
      ? DateFormat.jm().format(schedule.lunchTime)
      : null;

  bool getEODCheck() {
    if (schedule.eod) {}
  }

  void updateWith({
    bool hasLoggedIn,
    bool finishedLunch,
    bool eodCheck,
    DateTime currentLoginTime,
    DateTime lunchTime,
    DateTime lunchPunchTime,
  }) {
    this.hasLoggedIn = hasLoggedIn ?? this.hasLoggedIn;
    this.finishedLunch = finishedLunch ?? this.finishedLunch;
    this.eodCheck = eodCheck ?? this.eodCheck;
    this.currentLoginTime = currentLoginTime ?? this.currentLoginTime;
    this.lunchTime = lunchTime ?? this.lunchTime;
    this.lunchPunchTime = lunchPunchTime ?? this.lunchPunchTime;
    notifyListeners();
  }
}
