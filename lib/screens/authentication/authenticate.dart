import 'package:capstone_app/screens/authentication/register.dart';
import 'package:capstone_app/screens/authentication/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void switchView() {
    setState((() => showSignIn = !showSignIn));
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggle: switchView);
    } else {
      return Register(toggle: switchView);
    }
  }
}
