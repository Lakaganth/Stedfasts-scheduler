import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stedfasts_scheduler/models/driver_model.dart';
import 'package:stedfasts_scheduler/models/schedule_model.dart';
import 'package:stedfasts_scheduler/services/auth.dart';
import 'package:stedfasts_scheduler/services/driver_database.dart';
import 'package:stedfasts_scheduler/services/schedule_database.dart';
import 'package:stedfasts_scheduler/utilities/custom_flat_button.dart';

class VacationRequest extends StatefulWidget {
  final DateTime requestedDate;
  final DaySchedule schedule;
  final User user;
  VacationRequest({
    @required this.requestedDate,
    @required this.user,
    this.schedule,
  });

  @override
  _VacationRequestState createState() => _VacationRequestState();
}

class _VacationRequestState extends State<VacationRequest> {
  String get vacationOnlyDate =>
      DateFormat('dd-MMM-yyyy').format(widget.requestedDate);

  String vacationType;
  DaySchedule get schedule => widget.schedule;
  DaySchedule addVacation;
  DateTime get requestedDate => widget.requestedDate;

  void _submitVacationRequest(Driver driver) async {
    final scheduleDatabase =
        Provider.of<ScheduleDatabase>(context, listen: false);

    String scheduleId = '$requestedDate+${driver.id}';

    if (schedule.driverId != null) {
      addVacation = DaySchedule(
        id: schedule.id,
        driverId: schedule.driverId,
        driverName: schedule.driverName,
        shiftDate: schedule.shiftDate,
        weekNumber: schedule.weekNumber,
        shiftHours: schedule.shiftHours,
        vacationRequested: true,
        shiftType: schedule.shiftType,
        vacationType: vacationType,
        vacationAccepted: false,
      );
      await scheduleDatabase.setNewSchedule(addVacation);
    } else {
      addVacation = DaySchedule(
        id: scheduleId,
        driverId: driver.id,
        driverName: driver.name,
        shiftDate: requestedDate,
        weekNumber: weekNumber(requestedDate),
        shiftHours: 0,
        vacationRequested: true,
        vacationType: vacationType,
      );
      print("After Submit ${driver.email}");
      await scheduleDatabase.setNewSchedule(addVacation);
    }
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  @override
  Widget build(BuildContext context) {
    final driverDatabse = Provider.of<DriverDatabase>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Vacation Request"),
      ),
      body: StreamBuilder(
        stream: driverDatabse.driverProfile(widget.user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              List<Driver> drivers = snapshot.data;

              return buildVacationContainer(drivers[0]);
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
      ),
    );
  }

  Container buildVacationContainer(Driver driver) {
    return Container(
      height: 400.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Vacation Request",
              style: GoogleFonts.montserrat(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              "$vacationOnlyDate",
              style: GoogleFonts.montserrat(
                fontSize: 24.0,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            DropdownButton<String>(
              value: vacationType,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  vacationType = newValue;
                });
              },
              items: <String>['Vacation', 'Personal', 'Medical']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: GoogleFonts.montserrat(
                      fontSize: 24.0,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 50.0,
            ),
            CustomFlatButton(
              label: "Submit",
              onPressed: () =>
                  vacationType != null ? _submitVacationRequest(driver) : null,
            )
          ],
        ),
      ),
    );
  }
}
