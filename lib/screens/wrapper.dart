import 'package:capstone_app/screens/authentication/authenticate.dart';
import 'package:capstone_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_app/models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Return either Home or Authenticate Widget per login status.

    final user = Provider.of<TheUser?>(context);
    //Signed in or signed out determines which page:
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
