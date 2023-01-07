import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/listItem.dart';
import '../../models/meal.dart';
import '../../models/user.dart';
import '../../services/database.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

class IngrDetailPage extends StatefulWidget {
  const IngrDetailPage(
      {super.key, required this.index, required this.mealIndex});

  final index;
  final mealIndex;

  @override
  State<IngrDetailPage> createState() => _IngrDetailPageState();
}

class _IngrDetailPageState extends State<IngrDetailPage> {
  final _formKey = GlobalKey<FormState>();

  //TODO: Fix this-- Rather than a list of strings, change to dropdown that alters state.
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
    final index = widget.index;
    final mealIndex = widget.mealIndex;
    //Builds out each meal tile per stream.
    return StreamBuilder<List<Meal>>(
        stream: DatabaseService(uid: user!.uid).meals,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Detail Snapshot: ${snapshot.error}");
            return Text("Detail Snapshot: ${snapshot.error}");
          } else if (snapshot.hasData) {
            List<Meal> data = snapshot.data!;
            Meal meal = data[mealIndex];
            ListItem? item = meal.ingredients?[index];
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

                  //Button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue[400], onPrimary: Colors.white),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          data[mealIndex].ingredients?[index] = ListItem(
                              name: _currentName ?? item.name,
                              quantity: _currentQuant ?? item.quantity,
                              category: _currentCategory ?? item.category,
                              packSize: _currentPackSize ?? item.packSize,
                              store: _currentStore ?? item.store,
                              notes: _currentNotes ?? item.notes);
                          await DatabaseService(uid: user!.uid)
                              .updateMeals(data);
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Save'))
                ]));
          }
          //Loading widget if not yet populated by db.
          else {
            return Loading();
          }
        });
  }
}
