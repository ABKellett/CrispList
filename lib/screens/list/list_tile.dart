import 'package:capstone_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:capstone_app/models/listItem.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

class List_Tile extends StatefulWidget {
  List_Tile({super.key, required this.item, required this.index}); //const?

  final ListItem item;
  final int index;
  // List_Tile({required this.item});

  @override
  State<List_Tile> createState() => _List_TileState();
}

class _List_TileState extends State<List_Tile> {
  // bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser?>(context);

    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            child: ListTile(
              leading: Checkbox(
                value: widget.item.isChecked,
                onChanged: (value) {
                  //
                  ListItem oldItem = widget.item.copy();
                  setState(() => widget.item.isChecked = value!);

                  DatabaseService(uid: user!.uid)
                      .updateListItem(widget.item, oldItem);
                },
              ),
              title: Text(widget.item.name!),
              subtitle: Text(widget.item.quantity!.toString()),
              trailing: Icon(Icons.drag_handle),
              onTap: () {
                final slidable = Slidable.of(context)!;
                final isClosed =
                    slidable.actionPaneType.value == ActionPaneType.none;
                if (isClosed) {
                  slidable.openStartActionPane();
                } else {
                  slidable.close();
                }
              },
            )));
  }
}
