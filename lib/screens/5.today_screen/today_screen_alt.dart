import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stedfasts_scheduler/models/schedule_model.dart';
import 'package:stedfasts_scheduler/screens/5.today_screen/1.slideup_body.dart';
import 'package:stedfasts_scheduler/screens/5.today_screen/2.slideup_panel.dart';
import 'package:stedfasts_scheduler/services/auth.dart';
import 'package:stedfasts_scheduler/services/schedule_database.dart';

class TodayScreenAlt extends StatefulWidget {
  TodayScreenAlt({@required this.user});

  final User user;
  @override
  _TodayScreenAltState createState() => _TodayScreenAltState();
}

class _TodayScreenAltState extends State<TodayScreenAlt> {
  //  State
  User get user => widget.user;
  DaySchedule todaySchedule;
  DateTime _todayDateTime = DateTime.now();
  String get _todayDate => DateFormat('d-MM-yyyy').format(_todayDateTime);

  @override
  void initState() {
    super.initState();
  }

  _getTodaySchedule(List<DaySchedule> items) {
    List<DaySchedule> todayScheduleList = items.where((e) {
      var onlyTodayDate = DateFormat('d-MM-yyyy').format(_todayDateTime);
      var onlyElementDate = DateFormat('d-MM-yyyy').format(e.shiftDate);
      return onlyTodayDate == onlyElementDate;
    }).toList();

    return todaySchedule =
        todayScheduleList.length > 0 ? todayScheduleList[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    final ScheduleDatabase schedule = Provider.of<ScheduleDatabase>(context);

    return Scaffold(
      body: Container(
        child: StreamBuilder(
            stream: schedule.weeksHoursStream(widget.user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  List<DaySchedule> items = snapshot.data;

                  //  Get Only today's Schedule
                  _getTodaySchedule(items);

                  if (todaySchedule != null) {
                    return TodaySlidingPanel(
                      schedule: todaySchedule,
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: Text("No Shift"),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error , ${snapshot.error}"),
                  );
                } else {
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
                      Text('Error in loading data')
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}

class TodaySlidingPanel extends StatelessWidget {
  final DaySchedule schedule;

  TodaySlidingPanel({@required this.schedule});

  BorderRadius _panelRadius = BorderRadius.only(
      topLeft: Radius.circular(35.0), topRight: Radius.circular(35.0));

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropEnabled: true,
      borderRadius: _panelRadius,
      body: BuildTodaySlideupScreenBody(),
      panel: BuildTodaySlideupPanel.create(context, schedule),
      maxHeight: 500,
    );
  }
}
