import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:stedfasts_scheduler/screens/5.today_screen/today_screen.dart';
import 'package:stedfasts_scheduler/screens/5.today_screen/today_screen_alt.dart';
import 'package:stedfasts_scheduler/screens/6.schedule_screen/schedule_screen_alt.dart';
import 'package:stedfasts_scheduler/screens/7.accounts_screen/accounts_screen.dart';
import 'package:stedfasts_scheduler/services/auth.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          // TodayScreenView.create(context),
          TodayScreenAlt(user: widget.user),
          // TodayScreen(
          //   user: widget.user,
          // ),
          ScheduleScreenAlt.create(
            context,
            user: widget.user,
          ),
          AccountsScreen(user: widget.user),
        ],
        onPageChanged: (int index) {
          setState(() {
            _pageController.jumpToPage(index);
          });
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        color: Color(0xff714AC3),
        backgroundColor: Colors.white,
        buttonBackgroundColor: Color(0xff714AC3),
        height: 50.0,
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.bounceInOut,
        items: [
          Icon(Icons.today, size: 20, color: Colors.white),
          Icon(Icons.list, size: 20, color: Colors.white),
          Icon(Icons.person, size: 20, color: Colors.white),
        ],
        onTap: (int index) {
          setState(() {
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
