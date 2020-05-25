import 'package:flutter/foundation.dart';

enum ShiftType { A, B, C }

class DaySchedule {
  DaySchedule({
    @required this.id,
    @required this.driverId,
    @required this.driverName,
    @required this.shiftDate,
    @required this.shiftType,
    @required this.weekNumber,
    @required this.shiftHours,
    this.loginTime,
    this.lunchTime,
    this.eod = false,
  });

  String id;
  String driverId;
  String driverName;
  DateTime shiftDate;
  String shiftType;
  int weekNumber;
  int shiftHours;
  DateTime loginTime;
  DateTime lunchTime;
  bool eod;

  factory DaySchedule.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String driverId = data['driverId'];
    final String driverName = data['driverName'];
    final DateTime shiftDate =
        DateTime.parse(data['shiftDate'].toDate().toString());
    final String shiftType = data['shiftType'];
    final int weekNumber = data['weekNumber'];
    final int shiftHours = data['shiftHours'];
    final DateTime loginTime = data['loginTime'] != null
        ? DateTime.parse(data['loginTime'].toDate().toString())
        : null;
    final DateTime lunchTime = data['lunchTime'] != null
        ? DateTime.parse(data['lunchTime'].toDate().toString())
        : null;
    final bool eod = data['eod'];

    return DaySchedule(
      id: documentId,
      driverId: driverId,
      driverName: driverName,
      shiftDate: shiftDate,
      shiftType: shiftType,
      weekNumber: weekNumber,
      shiftHours: shiftHours,
      loginTime: loginTime != null ? loginTime : null,
      lunchTime: lunchTime != null ? lunchTime : null,
      eod: eod,
    );
  }

  Map<String, dynamic> toMap() {
    if (loginTime != null && lunchTime == null) {
      return {
        'driverId': driverId,
        'driverName': driverName,
        'shiftDate': shiftDate,
        'shiftType': shiftType,
        'weekNumber': weekNumber,
        'shiftHours': shiftHours,
        'loginTime': loginTime,
        'eod': eod
        // 'lunchTime': null,
      };
    } else if (lunchTime != null) {
      return {
        'driverId': driverId,
        'driverName': driverName,
        'shiftDate': shiftDate,
        'shiftType': shiftType,
        'weekNumber': weekNumber,
        'shiftHours': shiftHours,
        'loginTime': loginTime,
        'lunchTime': lunchTime,
        'eod': eod
      };
    } else {
      return {
        'driverId': driverId,
        'driverName': driverName,
        'shiftDate': shiftDate,
        'shiftType': shiftType,
        'weekNumber': weekNumber,
        'shiftHours': shiftHours,
        'eod': eod
      };
    }
  }
}
