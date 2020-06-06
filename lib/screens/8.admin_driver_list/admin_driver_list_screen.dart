import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stedfasts_scheduler/models/driver_model.dart';
import 'package:stedfasts_scheduler/screens/10.admin_add_new_schedule/admin_add_new_schedule.dart';
import 'package:stedfasts_scheduler/screens/9.admin_add_driver/admin_add_driver.dart';
import 'package:stedfasts_scheduler/services/auth.dart';
import 'package:stedfasts_scheduler/services/driver_database.dart';

class AdminDriverListScreen extends StatefulWidget {
  @override
  _AdminDriverListScreenState createState() => _AdminDriverListScreenState();
}

class _AdminDriverListScreenState extends State<AdminDriverListScreen> {
  @override
  Widget build(BuildContext context) {
    final DriverDatabase drivers = Provider.of<DriverDatabase>(context);
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
        centerTitle: true,
        elevation: 10,
        actions: [
          FlatButton(
            child: Text("Logout",
                style: GoogleFonts.pacifico(
                  fontSize: 18.0,
                  color: Colors.white,
                )),
            onPressed: () {
              auth.signOut();
            },
          )
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: drivers.driverStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                List<Driver> items = snapshot.data;

                return DriverListView(
                  driverList: items,
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AdminAddDriver.show(context),
        child: Icon(Icons.person_add),
      ),
    );
  }
}

class DriverListView extends StatefulWidget {
  final List<Driver> driverList;

  const DriverListView({@required this.driverList});

  @override
  _DriverListViewState createState() => _DriverListViewState();
}

class _DriverListViewState extends State<DriverListView> {
  List<Driver> get driverListStream => widget.driverList;

  List<String> driverNameList = [];
  List<Widget> favouriteList = [];
  List<Widget> normalList = [];
  TextEditingController searchController = TextEditingController();

  filterList() {
    List<Driver> drivers = [];
    drivers.addAll(driverListStream);
    drivers.sort((a, b) => a.name.compareTo(b.name));
    favouriteList = [];
    normalList = [];
    driverNameList = [];
    if (searchController.text.isNotEmpty) {
      drivers.retainWhere((driver) => driver.name
          .toLowerCase()
          .contains(searchController.text.toLowerCase()));
    }

    drivers.forEach((driver) {
      // if (driver.favourite) {
      //   favouriteList.add(
      //     Slidable(
      //       actionPane: SlidableDrawerActionPane(),
      //       actionExtentRatio: 0.25,
      //       secondaryActions: <Widget>[
      //         IconSlideAction(
      //           iconWidget: Icon(Icons.star),
      //           onTap: () {},
      //         ),
      //         IconSlideAction(
      //           iconWidget: Icon(Icons.more_horiz),
      //           onTap: () {},
      //         ),
      //       ],
      //       child: ListTile(
      //         leading: Stack(
      //           children: <Widget>[
      //             CircleAvatar(
      //               backgroundImage:
      //                   NetworkImage("http://placeimg.com/200/200/people"),
      //             ),
      //             Container(
      //                 height: 40,
      //                 width: 40,
      //                 child: Center(
      //                   child: Icon(
      //                     Icons.star,
      //                     color: Colors.yellow[100],
      //                   ),
      //                 ))
      //           ],
      //         ),
      //         title: Text(driver.name),
      //         subtitle: Text(driver.email),
      //       ),
      //     ),
      //   );
      // } else
      {
        normalList.add(
          Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            secondaryActions: <Widget>[
              IconSlideAction(
                  iconWidget: Icon(Icons.star),
                  onTap: () =>
                      AdminAddNewSchedule.show(context, driver: driver)),
              IconSlideAction(
                iconWidget: Icon(Icons.more_horiz),
                onTap: () {},
              ),
            ],
            child: FlatButton(
              onPressed: () =>
                  AdminAddNewSchedule.show(context, driver: driver),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                child: Container(
                  height: 120.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xffD6DAFC),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, .5),
                        blurRadius: 10.0,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(driver.avatarUrl),
                      radius: 25.0,
                    ),
                    title: Text(
                      driver.name,
                      style: GoogleFonts.montserrat(
                        fontSize: 18.0,
                        // color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      driver.email,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                        fontSize: 16.0,
                        // color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        driverNameList.add(driver.name);
      }
    });
    setState(() {
      driverNameList;
      favouriteList;
      normalList;
    });
  }

  @override
  void initState() {
    filterList();
    searchController.addListener(() {
      filterList();
    });

    super.initState();
  }

  @override
  void dispose() {
    searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentStr = "";
    return SafeArea(
      child: AlphabetListScrollView(
        strList: driverNameList,
        highlightTextStyle: TextStyle(color: Colors.pink),
        showPreview: true,
        itemBuilder: (context, index) => normalList[index],
        indexedHeight: (i) => 100,
        keyboardUsage: true,
        headerWidgetList: <AlphabetScrollListHeader>[
          AlphabetScrollListHeader(widgetList: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffix: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  labelText: "Search",
                ),
              ),
            )
          ], icon: Icon(Icons.search), indexedHeaderHeight: (index) => 80),
          AlphabetScrollListHeader(
              widgetList: favouriteList,
              icon: Icon(Icons.star),
              indexedHeaderHeight: (index) {
                return 80;
              }),
        ],
      ),
    );
  }
}
