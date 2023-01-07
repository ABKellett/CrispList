import 'package:capstone_app/models/event.dart';
import 'package:capstone_app/screens/list/list_page.dart';
import 'package:capstone_app/screens/meals/meal_page.dart';
import 'package:capstone_app/screens/tracker/tracker_page.dart';
import 'package:capstone_app/services/auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:capstone_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:capstone_app/models/listItem.dart';
import 'package:capstone_app/screens/Calendar/calendar.dart';

import '../../models/user.dart';
import '../../models/meal.dart';
import '../../models/tracker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int navIndex = 0;
  //Array of options for the NavBar to choose.
  final screens = [ListPage(), MealPage(), CalendarPage(), TrackerPage()];

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final user = Provider.of<TheUser?>(context);
    //Passes the state from several streams down through the widget tree. Enables live updates.
    return MultiProvider(
      providers: [
        //Grocery list provider.
        StreamProvider<List<ListItem>>.value(
          initialData: [],
          value: DatabaseService(uid: user!.uid).list,
        ),
        //Meal list provider.
        StreamProvider<List<Meal>>.value(
            value: DatabaseService(uid: user.uid).meals, initialData: []),
        //Calendar event provider, coming soon..
        // StreamProvider<List<CalEvent>>.value(
        //     value: DatabaseService(uid: user!.uid).events, initialData: []),
        //Tracker list provider.
        StreamProvider<List<Tracker>>.value(
            value: DatabaseService(uid: user!.uid).trackers, initialData: []),
      ],
      child: Scaffold(
          // return Scaffold(
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
                indicatorColor: Colors.blue.shade200,
                labelTextStyle: MaterialStateProperty.all(
                  TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                )),
            child: NavigationBar(
                height: 60,
                backgroundColor: Colors.grey[350],
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                animationDuration: Duration(seconds: 1),
                selectedIndex: navIndex,
                onDestinationSelected: (navIndex) =>
                    setState(() => this.navIndex = navIndex),
                destinations: [
                  NavigationDestination(
                      icon: Icon(Icons.list_outlined),
                      selectedIcon: Icon(Icons.list),
                      label: 'List'),
                  NavigationDestination(
                      icon: Icon(Icons.set_meal_outlined),
                      selectedIcon: Icon(Icons.set_meal),
                      label: 'Meals'),
                  NavigationDestination(
                      icon: Icon(Icons.calendar_month_outlined),
                      selectedIcon: Icon(Icons.calendar_month),
                      label: 'Calendar'),
                  NavigationDestination(
                      icon: Icon(Icons.edit_note), label: 'Tracker')
                ]),
          ),
          // backgroundColor: Colors.brown[50],
          appBar: AppBar(
            title: Text('CrispList'),
            backgroundColor: Color.fromARGB(188, 152, 22, 13),
            elevation: 0.0,
            actions: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('Logout'),
                style: TextButton.styleFrom(primary: Colors.white),
                onPressed: () async {
                  await _auth.signOut();
                },
              )
            ],
          ),
          //Equivalent of Fragments in one activity-- Home screen displays other screens as subwidgets.
          body: screens[navIndex]), //;
    );
  }
}
