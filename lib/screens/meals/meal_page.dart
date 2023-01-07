import 'package:capstone_app/models/listItem.dart';
import 'package:capstone_app/screens/meals/meal_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../services/database.dart';
import '../../models/meal.dart';

enum Actions { detail, delete }

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  @override
  Widget build(BuildContext context) {
    // List<ListItem> mealList = [
    //   ListItem(name: "Lasagne"),
    //   ListItem(name: "Lasagne")
    // ];
    final mealList = Provider.of<List<Meal>>(context) ?? [];

    ///Temp
    return SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        child: Scaffold(
            body: ListView.separated(
              itemCount: mealList.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                return Slidable(
                  key: UniqueKey(),
                  child: ListTile(
                    trailing: Icon(Icons.drag_handle),
                    title: Text(
                      mealList[index].name!,
                      style: TextStyle(fontSize: 28.0),
                    ),
                  ),
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    dismissible: DismissiblePane(
                      onDismissed: () =>
                          _onSliderButtonPress(index, Actions.delete, mealList),
                    ),
                    children: [
                      SlidableAction(
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          label: 'Delete',
                          onPressed: (context) => _onSliderButtonPress(
                              index, Actions.delete, mealList))
                    ],
                  ),
                  endActionPane:
                      ActionPane(motion: const BehindMotion(), children: [
                    SlidableAction(
                        backgroundColor: Colors.blue,
                        icon: Icons.description,
                        label: 'Ingredients',
                        onPressed: (context) => _onSliderButtonPress(
                            index, Actions.detail, mealList))
                  ]),
                );
              },
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                _onAddButtonPress();
              },
              label: Text("Add"),
              icon: Icon(Icons.add),
              backgroundColor: Color.fromARGB(189, 198, 30, 18),
            )));
  }

  void _onAddButtonPress() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: Container(),
          );
        });
  }

  dynamic _onSliderButtonPress(int index, Actions action, List<Meal> list) {
    //TODO: Should I pass in the list rather than the provider?
    final user = Provider.of<TheUser?>(context, listen: false);
    final item = list[index];

    switch (action) {
      case Actions.delete:
        Meal toRemove = list[index];
        // setState(() => list.removeAt(index));
        DatabaseService(uid: user!.uid).deleteFromList(toRemove);

        _confirmationPopup(
            context, '${item.name} has been deleted', Colors.red);
        break;
      case Actions.detail:
        // _showDetailPanel(index);
        Navigator.push(context,
            MaterialPageRoute<void>(builder: (BuildContext context) {
          return MealDetPage(
            mealIndex: index,
            mealList: list,
          );
        }));
        // return MealDetPage(
        //   index: index,
        //   mealList: list,
        // );
        break;
      //Future button confirmation messages here..
    }
  }

  void _confirmationPopup(BuildContext context, String message, Color color) {
    final popUp = SnackBar(content: Text(message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(popUp);
  }
}
