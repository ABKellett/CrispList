import 'package:capstone_app/models/tracker.dart';
import 'package:capstone_app/services/database.dart';
import 'package:capstone_app/shared/constants.dart';
import 'package:capstone_app/shared/loading.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class TrackDetPage extends StatefulWidget {
  const TrackDetPage({super.key, this.index});
  final index;

  @override
  State<TrackDetPage> createState() => _TrackDetPageState();
}

class _TrackDetPageState extends State<TrackDetPage> {
  final _formKey = GlobalKey<FormState>();

  String? _currentName;
  DateTime? _currentExpDate;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser?>(context);

    return StreamBuilder<List<Tracker>>(
        stream: DatabaseService(uid: user!.uid).trackers,
        builder: (context, snapshot) {
          // print(snapshot.hasData);
          if (snapshot.hasError) {
            print("Detail Snapshot: ${snapshot.error}");
            return Text("Detail Snapshot: ${snapshot.error}");
          } else if (snapshot.hasData) {
            List<Tracker> data = snapshot.data!;
            Tracker? item = data[widget.index];

            return Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  Text(
                    "Details",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),

                  //Name
                  TextFormField(
                    initialValue: item.name,
                    decoration:
                        textInputDecoration.copyWith(hintText: "Item Name"),
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter an item' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 20.0),

                  //Expiration Date
                  ElevatedButton(
                      onPressed: () async {
                        DateTime? theDate = await showDatePicker(
                            context: context,
                            initialDate: _currentExpDate ?? DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2100));
                        if (theDate == null) return;
                        setState(() => _currentExpDate = theDate);
                      },
                      child: Text("Select Date")),
                  SizedBox(height: 20.0),

                  //Button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue[400], onPrimary: Colors.white),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          data[widget.index] = Tracker(
                              name: _currentName ?? item.name,
                              expDate: _currentExpDate ?? item.expDate);
                          await DatabaseService(uid: user!.uid)
                              .updateTrackers(data);
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Save'))
                ]));
          } else {
            return Loading();
          }
        });
  }
}
