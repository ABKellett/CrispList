import 'package:capstone_app/models/listItem.dart';
import 'package:capstone_app/services/database.dart';
import 'package:capstone_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:capstone_app/models/user.dart';
import 'package:capstone_app/shared/constants.dart';
import 'package:provider/provider.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail({super.key, required this.index});
  final int index;

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  final _formKey = GlobalKey<FormState>();
  final List<String> quants = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];

  //form values
  String? _currentName;
  String? _currentQuant;
  String? _currentCategory;
  String? _currentPackSize;
  String? _currentStore;
  String? _currentNotes;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser?>(context);
    //Streams data state from firebase.
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user!.uid).userData,
        builder: (context, snapshot) {
          // print(snapshot.hasData);
          if (snapshot.hasError) {
            print("Detail Snapshot: ${snapshot.error}");
            return Text("Detail Snapshot: ${snapshot.error}");
          } else if (snapshot.hasData) {
            UserData data = snapshot.data!;
            ListItem? item = data.list[widget.index];
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
                    initialValue: item!.name,
                    decoration:
                        textInputDecoration.copyWith(hintText: "Item Name"),
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter an item' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 20.0),

                  //Quantity
                  DropdownButtonFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: "Quantity"),
                      value: _currentQuant ?? item.quantity,
                      items: quants.map((num) {
                        return DropdownMenuItem(value: num, child: Text(num));
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _currentQuant = '$val')),
                  SizedBox(height: 20.0),

                  //Category
                  TextFormField(
                    initialValue: item!.category,
                    decoration: textInputDecoration.copyWith(
                        hintText: "Category (ex: 'Produce')"),
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter a category' : null,
                    onChanged: (val) => setState(() => _currentCategory = val),
                  ),
                  SizedBox(height: 20.0),

                  //Package Size
                  TextFormField(
                    initialValue: item.packSize,
                    decoration:
                        textInputDecoration.copyWith(hintText: "Package Size"),
                    //validator: (val) => val!.isEmpty ? 'Please enter an item' : null,
                    onChanged: (val) => setState(() => _currentPackSize = val),
                  ),
                  SizedBox(height: 20.0),

                  //Store
                  TextFormField(
                    initialValue: item.store,
                    decoration: textInputDecoration.copyWith(hintText: "Store"),
                    //validator: (val) => val!.isEmpty ? 'Please enter an item' : null,
                    onChanged: (val) => setState(() => _currentStore = val),
                  ),
                  SizedBox(height: 20.0),

                  //Notes
                  //TODO: Make bigger space.
                  TextFormField(
                    initialValue: item.notes,
                    decoration: textInputDecoration.copyWith(hintText: "Notes"),
                    //validator: (val) => val!.isEmpty ? 'Please enter an item' : null,
                    onChanged: (val) => setState(() => _currentNotes = val),
                  ),

                  //Save Button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue[400], onPrimary: Colors.white),
                      onPressed: () async {
                        // print(_currentName);
                        // print(_currentQuant);
                        // print(_currentPackSize);
                        // print(_currentStore);
                        if (_formKey.currentState!.validate()) {
                          data.list[widget.index] = ListItem(
                              name: _currentName ?? item.name,
                              quantity: _currentQuant ?? item.quantity,
                              category: _currentCategory ?? item.category,
                              packSize: _currentPackSize ?? item.packSize,
                              store: _currentStore ?? item.store,
                              notes: _currentNotes ?? item.notes);
                          await DatabaseService(uid: user!.uid)
                              .updateUserData(data.list);
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Save'))
                ]));
          }
          //Loading widget until response from stream.
          else {
            return Loading();
          }
        });
  }
}
