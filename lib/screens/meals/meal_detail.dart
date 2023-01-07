import 'dart:async';

import 'package:capstone_app/models/listItem.dart';
import 'package:capstone_app/models/user.dart';
import 'package:capstone_app/screens/meals/ingredient_detail.dart';
import 'package:capstone_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/meal.dart';
import '../list/item_detail.dart';

class MealDetPage extends StatefulWidget {
  const MealDetPage(
      {super.key, required this.mealIndex, required this.mealList});
  final int mealIndex;
  final List<Meal> mealList;

  @override
  State<MealDetPage> createState() => _MealDetPageState();
}

class _MealDetPageState extends State<MealDetPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser?>(context);
    Meal meal = widget.mealList[widget.mealIndex];
    List<ListItem> list = meal.ingredients ?? [];
    return Scaffold(
        appBar: AppBar(
          title: Text(meal.name + " Ingredient List"),
          backgroundColor: Color.fromARGB(188, 152, 22, 13),
          elevation: 0.0,
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Ingredient tiles
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: ((context, index) {
                  final item = list[index];
                  return ListTile(
                    title: Text(item.name!),
                    leading: IconButton(
                        icon: Icon(Icons.format_list_bulleted),
                        onPressed: () {
                          _showDetailPanel(index, widget.mealIndex, context);
                        }),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        await DatabaseService(uid: user!.uid).addToList(item);
                        _confirmationPopup(
                            context,
                            'Item has been added to your grocery list!',
                            Colors.green);
                      },
                    ),
                  );
                })),
          ],
        ),
        //Add button
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // _onAddButtonPress();
          },
          label: Text("Add"),
          icon: Icon(Icons.add),
          backgroundColor: Color.fromARGB(189, 198, 30, 18),
        ));
  }

  //Calls Ingredient editing page.
  dynamic _showDetailPanel(int index, int mealIndex, BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: IngrDetailPage(index: index, mealIndex: mealIndex),
          );
        });
  }

  void _confirmationPopup(BuildContext context, String message, Color color) {
    final popUp = SnackBar(content: Text(message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(popUp);
  }
}
