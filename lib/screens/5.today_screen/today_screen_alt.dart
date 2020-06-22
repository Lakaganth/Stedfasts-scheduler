import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stedfasts_scheduler/models/schedule_model.dart';
import 'package:stedfasts_scheduler/screens/5.today_screen/build_panel.dart';
import 'package:stedfasts_scheduler/screens/5.today_screen/build_today_screen_body.dart';
import 'package:stedfasts_scheduler/screens/5.today_screen/build_today_screen_noshift_card.dart';
import 'package:stedfasts_scheduler/services/auth.dart';
import 'package:stedfasts_scheduler/services/schedule_database.dart';

class TodayScreenAlt extends StatelessWidget {
  TodayScreenAlt({@required this.user});

  final User user;
  final DateTime todayDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final ScheduleDatabase schedule = Provider.of<ScheduleDatabase>(context);
    return Scaffold(
      body: StreamBuilder(
        stream: schedule.weeksHoursStream(user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              List<DaySchedule> items = snapshot.data;

              List<DaySchedule> todaySchedule = items.where((e) {
                var onlyTodayDate =
                    DateFormat('d-MM-yyyy').format(todayDateTime);
                var onlyElementDate =
                    DateFormat('d-MM-yyyy').format(e.shiftDate);
                return onlyTodayDate == onlyElementDate;
              }).toList();
              if (todaySchedule.length > 0) {
                return SlidingUpPanel(
                  backdropEnabled: true,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0)),
                  maxHeight: 600,
                  parallaxEnabled: true,
                  body: BuildTodayScreenBody(
                    todayDateTime: todayDateTime,
                  ),
                  panel: BuildTodayScreenPanel(
                    schedule: todaySchedule[0],
                  ),
                );
              } else {
                return BuildNoShiftCard(
                  todayDateTime: todayDateTime,
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
        },
      ),
    );
  }
}
