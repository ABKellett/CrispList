import 'package:capstone_app/screens/wrapper.dart';
import 'package:capstone_app/services/auth.dart';
import 'package:capstone_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:capstone_app/models/user.dart';

import 'models/listItem.dart';
import 'models/meal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(StreamProvider<TheUser?>.value(
      initialData: null, value: AuthService().user, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<TheUser?>(context);
    // return MultiProvider(
    //   providers: [
    //     StreamProvider<List<ListItem>>.value(
    //       initialData: [],
    //       value: DatabaseService(uid: user!.uid).list,
    //     ),
    //     StreamProvider<List<Meal>>.value(
    //         value: DatabaseService(uid: user!.uid).meals, initialData: []),
    //     // StreamProvider<List<CalEvent>>.value(
    //     //     value: DatabaseService(uid: user!.uid).events, initialData: []),
    //     // StreamProvider<List<Tracker>>.value(
    //     //     value: DatabaseService(uid: user!.uid).trackers, initialData: []),
    //   ],

    // child: MaterialApp(home: Wrapper()),
    // );
    return MaterialApp(home: Wrapper());
  }
}
