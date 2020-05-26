import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stedfasts_scheduler/common/platform_exception_alert_dialog.dart';
import 'package:stedfasts_scheduler/models/schedule_model.dart';
import 'package:stedfasts_scheduler/screens/5.today_screen/today_screen_changeNotifier.dart';
import 'package:stedfasts_scheduler/utilities/custom_flat_button.dart';
import 'package:timer_builder/timer_builder.dart';

class BuildTodaySlideupPanel extends StatefulWidget {
  final DaySchedule schedule;
  final TodayScreenChangeNotifier model;

  BuildTodaySlideupPanel({@required this.schedule, @required this.model});

  static Widget create(BuildContext context, DaySchedule schedule) {
    return ChangeNotifierProvider<TodayScreenChangeNotifier>(
      create: (context) =>
          TodayScreenChangeNotifier(schedule: schedule, eodCheck: schedule.eod),
      child: Consumer<TodayScreenChangeNotifier>(
        builder: (context, model, _) =>
            BuildTodaySlideupPanel(model: model, schedule: schedule),
      ),
    );
  }

  @override
  _BuildTodaySlideupPanelState createState() => _BuildTodaySlideupPanelState();
}

class _BuildTodaySlideupPanelState extends State<BuildTodaySlideupPanel> {
  int get shiftStart => widget.model.getShiftStart();

  String get shiftLogin => widget.model.getShiftLogin;

  DateTime get shiftToLunch => widget.model.getShiftTimetoLunch;

  String get shiftLunch => widget.model.getLunchTime;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializing();
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }

    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  Future<void> loginNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'Channel ID', 'Channel title', 'channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Logged in',
        'Hello',
        // 'You\'ve logged in at $currentLoginTime. Lunch at $lunchTime',
        notificationDetails);
  }

  Future<void> fiveMinutestoLunchNotification() async {
    var timeDelayed = DateTime.now().add(Duration(seconds: 10));
    print("Before notification Showed");
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'second channel ID', 'second Channel title', 'second channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.schedule(
        1,
        'Hello',
        'Your scheduled lunch starts in 5 minutes!',
        timeDelayed,
        notificationDetails,
        androidAllowWhileIdle: true);
    print("Notificiaiton Showed");
  }

  void _todayLogin(BuildContext context) async {
    try {
      widget.model.todayLogin(context: context);
      loginNotification();
      fiveMinutestoLunchNotification();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(title: "Login failed", exception: e);
    }
  }

  void _todayLunch(BuildContext context) async {
    try {
      widget.model.todayLunch(context: context);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(title: "Lunch Login failed", exception: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Image.asset('assets/images/today/panel_slider.png'),
            _shiftStartTime(shiftStart),
            SizedBox(
              height: 30.0,
            ),
            !widget.model.hasLoggedIn && !widget.model.eodCheck
                ? CustomFlatButton(
                    label: "Login",
                    onPressed: !widget.model.hasLoggedIn
                        ? () => _todayLogin(context)
                        : null)
                : _showShiftLogin(),
            widget.model.hasLoggedIn && !widget.model.finishedLunch
                ? _buildTimers(context)
                : Text(''),
            SizedBox(
              height: 30.0,
            ),
            widget.model.eodCheck ? _showLunchLogin() : Text(''),
          ],
        ),
      ),
    );
  }

  Widget _shiftStartTime(int shiftstart) {
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

  Widget _buildLoginButton(BuildContext context) {
    return CustomFlatButton(
        label: "Login",
        onPressed:
            !widget.model.hasLoggedIn ? () => _todayLogin(context) : null);
  }

  Widget _showShiftLogin() {
    // DateFormat.jm().format(model.schedule.loginTime);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Text(
            "Login",
            style: GoogleFonts.metrophobic(
              fontSize: 28.0,
              color: Color(0xff646464),
            ),
          ),
          SizedBox(
            width: 60.0,
          ),
          Text(
            DateFormat.jm().format(widget.model.currentLoginTime != null
                ? widget.model.currentLoginTime
                : widget.model.schedule.loginTime),
            style: GoogleFonts.montserrat(fontSize: 42.0),
          ),
        ],
      ),
    );
  }

  _buildTimers(BuildContext context) {
    return TimerBuilder.scheduled([
      widget.model.currentLoginTime,
      widget.model.lunchTime,
    ], builder: (context) {
      final now = DateTime.now();
      final started = now.compareTo(widget.model.currentLoginTime) >= 0;
      final ended = now.compareTo(widget.model.lunchTime) >= 0;

      return started
          ? ended
              ? CustomFlatButton(
                  label: "Lunch",
                  onPressed: widget.model.hasLoggedIn
                      ? () => _todayLunch(context)
                      : null,
                )
              : _startTimer(context)
          : Text("Not Started");
    });
  }

  _startTimer(BuildContext context) {
    return Center(
      child: CircularCountDownTimer(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 3,
        duration: 10,
        fillColor: Colors.red,
        color: Colors.white,
        strokeWidth: 5.0,
      ),
    );
  }

  _showLunchLogin() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Text(
            "Lunch",
            style: GoogleFonts.metrophobic(
              fontSize: 28.0,
              color: Color(0xff646464),
            ),
          ),
          SizedBox(
            width: 50.0,
          ),
          Text(
            widget.model.lunchPunchTime != null
                ? "${DateFormat.jm().format(widget.model.lunchPunchTime)}"
                : "${DateFormat.jm().format(widget.model.schedule.lunchTime)}",
            style: GoogleFonts.montserrat(fontSize: 42.0),
          ),
        ],
      ),
    );
  }
}
