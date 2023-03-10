import 'package:flutter/material.dart';
import 'package:capstone_app/shared/constants.dart';
import 'package:capstone_app/models/listItem.dart';
import 'package:capstone_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:capstone_app/models/user.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
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

    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          Text(
            "New Item",
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20.0),

          //Name
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: "Item Name"),
            validator: (val) => val!.isEmpty ? 'Please enter an item' : null,
            onChanged: (val) => setState(() => _currentName = val),
          ),
          SizedBox(height: 20.0),

          //Quantity
          DropdownButtonFormField(
              decoration: textInputDecoration.copyWith(hintText: "Quantity"),
              value: _currentQuant,
              items: quants.map((num) {
                return DropdownMenuItem(value: num, child: Text(num));
              }).toList(),
              onChanged: (val) => setState(() => _currentQuant = '$val')),
          SizedBox(height: 20.0),

          //Category
          TextFormField(
            decoration: textInputDecoration.copyWith(
                hintText: "Category (ex: 'Produce')"),
            validator: (val) => val!.isEmpty ? 'Please enter a category' : null,
            onChanged: (val) => setState(() => _currentCategory = val),
          ),
          SizedBox(height: 20.0),

          //Package Size
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: "Package Size"),
            //validator: (val) => val!.isEmpty ? 'Please enter an item' : null,
            onChanged: (val) => setState(() => _currentPackSize = val),
          ),
          SizedBox(height: 20.0),

          //Store
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: "Store"),
            //validator: (val) => val!.isEmpty ? 'Please enter an item' : null,
            onChanged: (val) => setState(() => _currentStore = val),
          ),
          SizedBox(height: 20.0),

          //Notes
          //TODO: Make bigger space.
          TextFormField(
            decoration: textInputDecoration.copyWith(hintText: "Notes"),
            //validator: (val) => val!.isEmpty ? 'Please enter an item' : null,
            onChanged: (val) => setState(() => _currentNotes = val),
          ),

          //Save Button
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue[400], onPrimary: Colors.white),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  ListItem? newItem = ListItem(
                      name: _currentName,
                      quantity: _currentQuant,
                      category: _currentCategory,
                      packSize: _currentPackSize,
                      store: _currentStore,
                      notes: _currentNotes);

                  DatabaseService(uid: user!.uid).addToList(newItem);
                  Navigator.pop(context);
                }
              },
              child: Text('Save'))
        ]));
  }
}
