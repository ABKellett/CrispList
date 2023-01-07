import 'package:capstone_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:capstone_app/services/auth.dart';

import '../../shared/loading.dart';

class Register extends StatefulWidget {
  final toggle;
  const Register({Key? key, this.toggle}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //Text Field State
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    //Loading widget until loaded up with sign in screen.
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Sign up for CrispList'),
              actions: <Widget>[
                ElevatedButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Sign In'),
                  onPressed: () {
                    widget.toggle();
                  },
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              //Login details form.
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        }),
                    SizedBox(height: 20.0),
                    TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? "Enter a password 6+ characters long"
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        }),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.pink[400], onPrimary: Colors.white),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // print(email);
                            // print(password);
                            setState(() => loading = true);
                            dynamic result = await _auth
                                .registerWithEmailPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error = "Please supply a valid email";
                                loading = false;
                              });
                            }
                            //Stream updates, so no need for 'else'.
                          }
                        },
                        child: Text('Register')),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
