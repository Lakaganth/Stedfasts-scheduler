import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stedfasts_scheduler/models/schedule_model.dart';
import 'package:stedfasts_scheduler/services/auth.dart';
import 'package:stedfasts_scheduler/services/schedule_database.dart';
import 'package:stedfasts_scheduler/utilities/constants.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({@required this.user});
  final User user;
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  get screenWidth => MediaQuery.of(context).size.width;
  get screenHeight => MediaQuery.of(context).size.height;
  User get user => widget.user;
  CalendarController _calendarController;

  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  DateTime _selectedDate = DateTime.now();
  Color _markercolor;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
    _selectedEvents = [];
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
    // print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final scheduleDatase =
        Provider.of<ScheduleDatabase>(context, listen: false);
    return StreamBuilder(
      stream: scheduleDatase.weeksHoursStream(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          List<DaySchedule> items = snapshot.data;
          List<DaySchedule> weeksScheduleList = snapshot.data;
          // List<DaySchedule> weeksScheduleList = items.where((e) {
          //   int _selectedWeekNumber = weekNumber(_selectedDate);
          //   return e.weekNumber == _selectedWeekNumber;
          // }).toList();
          if (snapshot.hasData) {
            return _buildScheduleScaffold(weeksScheduleList);
          }
          //Stream data has Error
          else if (snapshot.hasError) {
            Center(
              child: Text("Error , ${snapshot.error}"),
            );
          } else {
            _events = {};
            _selectedEvents = [];
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
    );
  }

  Scaffold _buildScheduleScaffold(List<DaySchedule> weeksScheduleList) {
    _events = _groupEvents(weeksScheduleList);

    List<DaySchedule> currentWeeksScheduleList = weeksScheduleList.where((e) {
      int _selectedWeekNumber = weekNumber(_selectedDate);
      return e.weekNumber == _selectedWeekNumber;
    }).toList();

    int totalWeekHours = 0;

    currentWeeksScheduleList.forEach((day) {
      totalWeekHours = totalWeekHours + day.shiftHours;
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 25.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                calendarController: _calendarController,
                events: _events,
                initialCalendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                formatAnimation: FormatAnimation.slide,
                headerStyle: HeaderStyle(
                  centerHeaderTitle: true,
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  formatButtonShowsNext: false,
                ),
                calendarStyle: CalendarStyle(
                  canEventMarkersOverflow: false,
                  selectedColor: Colors.orange,
                  markersColor: Colors.black,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black),
                ),
                availableGestures: AvailableGestures.all,
                onDaySelected: (date, events) {
                  setState(() {
                    _selectedDate = date;
                    _selectedEvents = events;
                  });
                },
              ),
              _buildSelectedDateInfoContainer(),
              Divider(
                height: 10.0,
                color: Colors.grey,
                thickness: 1.5,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Shifts for this Week",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 18.0,
                  letterSpacing: 3.5,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "$totalWeekHours Hours",
                style: GoogleFonts.montserrat(
                  fontSize: 32.0,
                  decoration: TextDecoration.underline,
                ),
              ),
              _selectedWeekScheduleListView(currentWeeksScheduleList),
            ],
          ),
        ),
      ),
    );
  }

  _buildSelectedDateInfoContainer() {
    print(_selectedEvents.length > 0 ? _selectedEvents[0].driverId : "Hello");

    String _shiftStartTime;
    if (_selectedEvents.length > 0) {
      switch (_selectedEvents[0].shiftHours) {
        case 10:
          {
            _shiftStartTime = "8:00 AM";
          }
          break;
        case 8:
          {
            _shiftStartTime = "12:00 PM";
          }
          break;
        case 6:
          {
            _shiftStartTime = "6:00 PM";
          }
          break;
      }
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
      child: Container(
        height: 150.0,
        width: screenWidth,
        decoration: BoxDecoration(
          color: Color(0xff1E1D1D),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, .3),
              blurRadius: 20.0,
              offset: Offset(5, 12),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _selectedEvents.length > 0
                ? Text(
                    " ${DateFormat("dd-MM-yyyy").format(_selectedDate)}",
                    textAlign: TextAlign.center,
                    style: kDayScheduleInfoTextStyle,
                  )
                : Text(''),
            SizedBox(
              height: 20.0,
            ),
            _selectedEvents.length > 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Shift Starts :",
                        style: kDayScheduleInfoTextStyle,
                      ),
                      Text(
                        "$_shiftStartTime",
                        style: kDayScheduleInfoTextStyle,
                      )
                    ],
                  )
                : Text(
                    "Select a Date",
                    textAlign: TextAlign.center,
                    style: kDayScheduleInfoTextStyle,
                  ),
            SizedBox(
              height: 20.0,
            ),
            _selectedEvents.length > 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Hours :",
                        style: kDayScheduleInfoTextStyle,
                      ),
                      Text(
                        "${_selectedEvents[0].shiftHours} Hrs",
                        style: kDayScheduleInfoTextStyle,
                      )
                    ],
                  )
                : Text(''),
          ],
        ),
      ),
    );
  }

  Widget _selectedWeekScheduleListView(List<DaySchedule> weeksScheduleList) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: weeksScheduleList.length,
        itemBuilder: (BuildContext context, int index) {
          return _scheduleListView(weeksScheduleList[index]);
        },
      ),
    );
  }

  Widget _scheduleListView(DaySchedule schedule) {
    String scheduleDay = DateFormat('EEEE').format(schedule.shiftDate);
    String shiftDate = DateFormat('dd-MM-yyyy').format(schedule.shiftDate);
    String _shiftStartTime;
    Color _borderColor;

    switch (schedule.shiftHours) {
      case 10:
        {
          _shiftStartTime = "8:00 AM";
          _borderColor = Colors.purple[200];
        }
        break;
      case 8:
        {
          _shiftStartTime = "12:00 PM";
          _borderColor = Colors.green;
        }
        break;
      case 6:
        {
          _shiftStartTime = "6:00 PM";
          _borderColor = Colors.blue;
        }
        break;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${shiftDate} \n $scheduleDay",
            textAlign: TextAlign.right,
            style: GoogleFonts.montserrat(
              fontSize: 18.0,
            ),
          ),
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: _borderColor,
                width: 5.0,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(50.0),
              // color: Colors.amber,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(18.0, 30.0, 2.0, 2.0),
              child: Text(
                "${schedule.shiftHours} Hrs",
                style: GoogleFonts.montserrat(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          Text(
            "$_shiftStartTime",
            style: GoogleFonts.montserrat(
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}
