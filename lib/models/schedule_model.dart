import 'package:flutter/foundation.dart';

enum ShiftType { A, B, C }
enum VacationType { sick, vacation, personal }

class DaySchedule {
  DaySchedule({
    @required this.id,
    @required this.driverId,
    @required this.driverName,
    @required this.shiftDate,
    this.shiftType,
    @required this.weekNumber,
    @required this.shiftHours,
    this.loginTime,
    this.lunchTime,
    this.lunchFinishTime,
    this.logoutTime,
    this.eod = false,
    this.vacationRequested = false,
    this.vacationAccepted = false,
    this.vacationType,
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
  DateTime lunchFinishTime;
  DateTime logoutTime;
  bool eod;
  bool vacationRequested;
  bool vacationAccepted;
  String vacationType;

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
    final DateTime lunchFinishTime = data['lunchFinishTime'] != null
        ? DateTime.parse(data['lunchFinishTime'].toDate().toString())
        : null;
    final DateTime logoutTime = data['logoutTime'] != null
        ? DateTime.parse(data['logoutTime'].toDate().toString())
        : null;
    final bool eod = data['eod'];

    final String vacationType = data['vacationType'];
    final bool vacationAccepted = data['vacationAccepted'];
    final bool vacationRequested = data['vacationRequested'];

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
      lunchFinishTime: lunchFinishTime != null ? lunchFinishTime : null,
      logoutTime: logoutTime != null ? logoutTime : null,
      eod: eod,
      vacationRequested: vacationRequested,
      vacationType: vacationType,
      vacationAccepted: vacationAccepted,
    );
  }

  Map<String, dynamic> toMap() {
    if (loginTime != null &&
        lunchTime == null &&
        lunchFinishTime == null &&
        logoutTime == null) {
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
    } else if (lunchTime != null &&
        lunchFinishTime == null &&
        logoutTime == null) {
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
    } else if (lunchFinishTime != null && logoutTime == null) {
      return {
        'driverId': driverId,
        'driverName': driverName,
        'shiftDate': shiftDate,
        'shiftType': shiftType,
        'weekNumber': weekNumber,
        'shiftHours': shiftHours,
        'loginTime': loginTime,
        'lunchTime': lunchTime,
        'lunchFinishTime': lunchFinishTime,
        'eod': eod
      };
    } else if (logoutTime != null) {
      return {
        'driverId': driverId,
        'driverName': driverName,
        'shiftDate': shiftDate,
        'shiftType': shiftType,
        'weekNumber': weekNumber,
        'shiftHours': shiftHours,
        'loginTime': loginTime,
        'lunchTime': lunchTime,
        'lunchFinishTime': lunchFinishTime,
        'logoutTime': logoutTime,
        'eod': eod
      };
    } else if (vacationRequested == true) {
      return {
        'driverId': driverId,
        'driverName': driverName,
        'shiftDate': shiftDate,
        'shiftType': shiftType,
        'weekNumber': weekNumber,
        'shiftHours': shiftHours,
        'vacationRequested': vacationRequested,
        'vacationType': vacationType,
        'vacationAccepted': vacationAccepted,
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
        'vacationRequested': vacationRequested,
        'eod': eod,
      };
    }
  }
}
