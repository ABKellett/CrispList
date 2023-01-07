import 'package:capstone_app/screens/list/item_detail.dart';
import 'package:capstone_app/screens/list/new_item.dart';
import 'package:capstone_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/listItem.dart';
import 'package:capstone_app/screens/list/list_tile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/user.dart';

enum Actions { detail, delete }

//////Main List Page
class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser?>(context);
    final list = Provider.of<List<ListItem>>(context) ?? [];
    //Needs to sort to keep items sorted by category.
    //TODO: This causes a bug when adding ingredients from Meal ingredient page. Fix timing.
    if (list.isNotEmpty) {
      list.sort((a, b) => a.category!.compareTo(b.category!));
      DatabaseService(uid: user!.uid).updateUserData(list);
    }
    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: ((context, index) {
                    final item = list[index];
                    return Slidable(
                      // key: Key(item.name!),
                      key: UniqueKey(),
                      child: List_Tile(
                        item: item,
                        index: index,
                      ),
                      startActionPane: ActionPane(
                        motion: const StretchMotion(),
                        dismissible: DismissiblePane(
                          onDismissed: () =>
                              _onSliderButtonPress(index, Actions.delete, list),
                        ),
                        children: [
                          SlidableAction(
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                              label: 'Delete',
                              onPressed: (context) => _onSliderButtonPress(
                                  index, Actions.delete, list))
                        ],
                      ),
                      endActionPane:
                          ActionPane(motion: const BehindMotion(), children: [
                        SlidableAction(
                            backgroundColor: Colors.blue,
                            icon: Icons.description,
                            label: 'Details',
                            onPressed: (context) => _onSliderButtonPress(
                                index, Actions.detail, list))
                      ]),
                    );
                  })),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _onAddButtonPress();
            },
            label: Text("Add"),
            icon: Icon(Icons.add),
            backgroundColor: Color.fromARGB(189, 198, 30, 18),
          )),
    );
  }

  //Calls item detail page.
  void _showDetailPanel(int index) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: ItemDetail(
              index: index,
            ),
          );
        });
  }

  //Calls new item creation page.
  void _onAddButtonPress() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: NewItem(),
          );
        });
  }

  //Slider buttons.
  void _onSliderButtonPress(int index, Actions action, List<ListItem> list) {
    final user = Provider.of<TheUser?>(context, listen: false);
    final item = list[index];

    switch (action) {
      case Actions.delete:
        ListItem toRemove = list[index];
        // setState(() => list.removeAt(index));
        DatabaseService(uid: user!.uid).deleteFromList(toRemove);

        _confirmationPopup(
            context, '${item.name} has been deleted', Colors.red);
        break;
      case Actions.detail:
        _showDetailPanel(index);
        break;
      //Future button confirmation messages here..
    }
  }

  void _confirmationPopup(BuildContext context, String message, Color color) {
    final popUp = SnackBar(content: Text(message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(popUp);
  }
}
