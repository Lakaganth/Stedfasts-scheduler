import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stedfasts_scheduler/models/driver_model.dart';
import 'package:stedfasts_scheduler/models/schedule_model.dart';
import 'package:stedfasts_scheduler/services/schedule_database.dart';
import 'package:stedfasts_scheduler/utilities/form_submit_button.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminAddNewSchedule extends StatefulWidget {
  AdminAddNewSchedule({@required this.driver});

  final Driver driver;

  static Future<void> show(BuildContext context,
      {@required Driver driver}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AdminAddNewSchedule(
          driver: driver,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AdminAddNewScheduleState createState() => _AdminAddNewScheduleState();
}

class _AdminAddNewScheduleState extends State<AdminAddNewSchedule> {
  Driver get driver => widget.driver;

  @override
  Widget build(BuildContext context) {
    final scheduleDatabase =
        Provider.of<ScheduleDatabase>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Schedule"),
        ),
        body: StreamBuilder(
          stream: scheduleDatabase.weeksHoursStreamDriver(driver),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                List<DaySchedule> items = snapshot.data;
                return AddScheduleForm(
                  driverFullSchedule: items,
                  driver: driver,
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error , ${snapshot.error}"),
                );
              } else {
                return Container(
                  child: Text("No Data"),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class AddScheduleForm extends StatefulWidget {
  AddScheduleForm({@required this.driverFullSchedule, @required this.driver});

  final List<DaySchedule> driverFullSchedule;
  final Driver driver;

  @override
  _AddScheduleFormState createState() => _AddScheduleFormState();
}

class _AddScheduleFormState extends State<AddScheduleForm> {
  List<DaySchedule> get driverFullSchedule => widget.driverFullSchedule;
  Driver get driver => widget.driver;
  CalendarController _calendarController;
  DateTime _selectedDate = DateTime.now();

  int _selectedDateWeekNumber;
  int totalHours = 0;
  int remainingHours = 60;
  int totalWeekHours = 0;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  ShiftType shiftType;
  int shiftHours;
  bool canAddSchedule = true;

  String scheduleId() => '$_selectedDate+${widget.driver.id}';

  @override
  void initState() {
    _calendarController = CalendarController();
    _selectedDateWeekNumber = weekNumber(_selectedDate);

    _events = {};
    _selectedEvents = [];
    // checkOneDaysBefore(driverFullSchedule);
    checkSixthDay(driverFullSchedule, DateTime.now(), 1);
    checkNextDays(driverFullSchedule, DateTime.now(), 1);
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<DaySchedule> allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      DateTime date = event.shiftDate;
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  void checkpreviousDays(
      List<DaySchedule> driverFullSchedule, DateTime selectedDate, int i) {
    DateTime previousDate = selectedDate.subtract(Duration(days: i));
    var onlyPreviousDate = DateFormat('dd-MM-yyyy').format(previousDate);

    driverFullSchedule.forEach((e) {
      var onlyscheduleDate = DateFormat('d-MM-yyyy').format(e.shiftDate);
      if (onlyscheduleDate == onlyPreviousDate) {
        if (i != 5) {
          checkpreviousDays(driverFullSchedule, selectedDate, i + 1);
        } else {
          setState(() {
            canAddSchedule = false;
          });
        }
      }
    });
  }

  void checkSixthDay(
      List<DaySchedule> driverFullSchedule, DateTime selectedDate, int i) {
    DateTime prevSixthDate = selectedDate.subtract(Duration(days: 6));

    var onlyPrevSixthDate = DateFormat('dd-MM-yyyy').format(prevSixthDate);

    driverFullSchedule.forEach((e) {
      var onlyscheduleDate = DateFormat('d-MM-yyyy').format(e.shiftDate);
      if (onlyscheduleDate == onlyPrevSixthDate) {
        checkpreviousDays(driverFullSchedule, selectedDate, i);
      }
    });
  }

  checkNextDays(
      List<DaySchedule> driverFullSchedule, DateTime selectedDate, int i) {
    DateTime nextDate = selectedDate.add(Duration(days: i));
    var onlyNextDate = DateFormat('dd-MM-yyyy').format(nextDate);

    driverFullSchedule.forEach((e) {
      var onlyscheduleDate = DateFormat('d-MM-yyyy').format(e.shiftDate);
      if (onlyscheduleDate == onlyNextDate) {
        if (i != 1) {
          checkNextDays(driverFullSchedule, selectedDate, i - 1);
        } else {
          setState(() {
            canAddSchedule = false;
          });
        }
      }
    });
  }

  void checkNextSixthDay(
      List<DaySchedule> driverFullSchedule, DateTime selectedDate, int i) {
    DateTime nextSixthDate = selectedDate.add(Duration(days: 6));

    var onlyNextSixthDate = DateFormat('dd-MM-yyyy').format(nextSixthDate);

    driverFullSchedule.forEach((e) {
      var onlyscheduleDate = DateFormat('d-MM-yyyy').format(e.shiftDate);
      if (onlyscheduleDate == onlyNextSixthDate) {
        checkNextDays(driverFullSchedule, selectedDate, 5);
      }
    });
  }

  _submit() async {
    final scheduleDatabase =
        Provider.of<ScheduleDatabase>(context, listen: false);

    final DaySchedule schedule = DaySchedule(
        id: scheduleId(),
        driverId: widget.driver.id,
        driverName: widget.driver.name,
        shiftDate: _selectedDate,
        shiftType: shiftType.toString(),
        weekNumber: _selectedDateWeekNumber,
        shiftHours: shiftHours);
    await scheduleDatabase.setNewSchedule(schedule);
  }

  @override
  Widget build(BuildContext context) {
    List<DaySchedule> currentWeeksScheduleList = driverFullSchedule.where((e) {
      int _selectedWeekNumber = weekNumber(_selectedDate ?? DateTime.now());
      return e.weekNumber == _selectedWeekNumber;
    }).toList();

    checkSixthDay(driverFullSchedule, _selectedDate, 1);
    checkNextSixthDay(driverFullSchedule, _selectedDate, 1);

    _events = _groupEvents(driverFullSchedule);

    totalWeekHours = 0;
    currentWeeksScheduleList.forEach((day) {
      totalWeekHours = totalWeekHours + day.shiftHours;
    });

    final scheduleDatabase =
        Provider.of<ScheduleDatabase>(context, listen: false);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Driver Name',
              ),
              initialValue: widget.driver.name,
            ),
            SizedBox(
              height: 32.0,
            ),
            TableCalendar(
              calendarController: _calendarController,
              events: _events,
              startingDayOfWeek: StartingDayOfWeek.monday,
              initialCalendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                canEventMarkersOverflow: true,
                todayColor: Colors.orange,
                selectedColor: Colors.purple,
                markersColor: Colors.black,
                todayStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              onDaySelected: (day, events) {
                setState(() {
                  _selectedDate = day;
                  _selectedDateWeekNumber = weekNumber(day);
                  _selectedEvents = events;
                  canAddSchedule = true;
                });
              },
            ),
            ..._selectedEvents.map(
              (hours) => ListTile(
                title: hours.shiftHours > 0
                    ? Text(
                        "Hours for the selected day : ${hours.shiftHours}",
                        style: TextStyle(fontSize: 18.0),
                      )
                    : Text(''),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () async {
                    var onlyWidgetDate =
                        DateFormat('d-MM-yyyy').format(_selectedDate);
                    var onlyStreamDate =
                        DateFormat('d-MM-yyyy').format(hours.shiftDate);

                    if (onlyWidgetDate == onlyStreamDate) {
                      await scheduleDatabase.deleteScheduleForDriver(
                          scheduleId: hours.id);
                    }
                  },
                ),
              ),
            ),
            canAddSchedule ? _selectShift() : Text("Can't Add More shifts"),
            SizedBox(
              height: 32.0,
            ),
            Text(
              "Hours for the week : $totalWeekHours",
              style: TextStyle(fontSize: 24.0),
            ),
            Text(
              "Hours for the week : ${60 - totalWeekHours} ",
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(
              height: 32.0,
            ),
            canAddSchedule
                ? FormSubmitButton(
                    text: "Save",
                    onPressed: totalHours > 60 ? null : _submit,
                  )
                : Text("Can't Add More shifts"),
          ],
        ),
      ),
    );
  }

  Widget _selectShift() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Select Shift",
          style: TextStyle(fontSize: 18.0),
        ),
        SizedBox(
          height: 16.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              onPressed: totalWeekHours >= 51
                  ? null
                  : () {
                      setState(() {
                        shiftType = ShiftType.A;
                        shiftHours = 10;
                      });
                    },
              color: shiftType == ShiftType.A ? Colors.green : null,
              child: Text("A"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            RaisedButton(
              onPressed: totalWeekHours >= 53
                  ? null
                  : () {
                      setState(() {
                        shiftType = ShiftType.B;
                        shiftHours = 8;
                      });
                    },
              color: shiftType == ShiftType.B ? Colors.green : null,
              child: Text("B"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            RaisedButton(
              onPressed: totalWeekHours > 55
                  ? null
                  : () {
                      setState(() {
                        shiftType = ShiftType.C;
                        shiftHours = 5;
                      });
                    },
              color: shiftType == ShiftType.C ? Colors.green : null,
              child: Text("C"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
