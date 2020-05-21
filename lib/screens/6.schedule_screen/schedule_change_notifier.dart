import 'package:flutter/cupertino.dart';
import 'package:stedfasts_scheduler/models/schedule_model.dart';
import 'package:stedfasts_scheduler/services/auth.dart';

class ScheduleScreenChangeModel with ChangeNotifier {
  ScheduleScreenChangeModel({
    this.selectedDate,
    this.events,
    this.selectedEvents,
    this.schedules,
    @required this.user,
  });
  DateTime selectedDate;
  final User user;
  List<dynamic> selectedEvents = [];
  List<DaySchedule> schedules = [];
  Map<DateTime, List<dynamic>> events;

  void groupEvents() {
    Map<DateTime, List<dynamic>> data = {};
    schedules.forEach((event) {
      DateTime date = event.shiftDate;
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    updateWith(events: data);
  }

  void updateSelecteddate(DateTime date) => updateWith(selectedDate: date);

  void updateSelectedEvents({DateTime date, List<dynamic> events}) =>
      updateWith(selectedEvents: events, selectedDate: date);

  void updateWith({
    DateTime selectedDate,
    Map<DateTime, List<dynamic>> events,
    List<dynamic> selectedEvents,
  }) {
    this.selectedDate = selectedDate ?? this.selectedDate;
    this.events = events ?? this.events;
    this.selectedEvents = selectedEvents ?? this.selectedEvents;
    notifyListeners();
  }
}
