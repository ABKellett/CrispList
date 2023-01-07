import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:capstone_app/screens/tracker/trackerDetPage.dart';

import '../../models/tracker.dart';
import '../../models/user.dart';
import '../../services/database.dart';

enum Actions { detail, delete }

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  bool isUnsorted = true;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser?>(context);
    final trackList = Provider.of<List<Tracker>>(context) ?? [];
    //Sorts tiles per expiration date and by extension, severity color.
    if (trackList.isNotEmpty && isUnsorted) {
      trackList.sort((a, b) => a.expDate!.compareTo(b.expDate));
      DatabaseService(uid: user!.uid).updateTrackers(trackList);
      isUnsorted = false;
    }

    return SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        child: Scaffold(
            //Builds out expiration date trackers, streamed in from firebase.
            body: ListView.builder(
              itemCount: trackList.length,
              itemBuilder: (context, index) {
                return Slidable(
                  key: UniqueKey(),
                  child: ListTile(
                    trailing: Icon(Icons.drag_handle),
                    title: Text(
                      trackList[index].name + isExpired(trackList[index]),
                      style: TextStyle(fontSize: 18.0),
                    ),
                    tileColor: setColor(trackList[index]),
                  ),
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    dismissible: DismissiblePane(
                      onDismissed: () => _onSliderButtonPress(
                          index, Actions.delete, trackList),
                    ),
                    children: [
                      SlidableAction(
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          label: 'Delete',
                          onPressed: (context) => _onSliderButtonPress(
                              index, Actions.delete, trackList))
                    ],
                  ),
                  endActionPane:
                      ActionPane(motion: const BehindMotion(), children: [
                    SlidableAction(
                        backgroundColor: Colors.blue,
                        icon: Icons.description,
                        label: 'Edit',
                        onPressed: (context) => _onSliderButtonPress(
                            index, Actions.detail, trackList))
                  ]),
                );
              },
            ),
            //Add button
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                _onAddButtonPress();
              },
              label: Text("Add"),
              icon: Icon(Icons.add),
              backgroundColor: Color.fromARGB(189, 198, 30, 18),
            )));
  }

  //Determines color of each tracker tile. Determined here rather than constantly
  //updating a 'time until expiry' value in Tracker object/DB.
  Color setColor(Tracker tracker) {
    DateTime today = DateTime.now();
    final daysLeft = tracker.expDate.difference(today).inDays;
    if (daysLeft < 0) {
      return Colors.red.shade900;
    } else if (daysLeft >= 0 && daysLeft <= 2) {
      return Colors.red;
    } else if (daysLeft > 2 && daysLeft < 5) {
      return Colors.orange;
    } else if (daysLeft >= 5 && daysLeft < 8) {
      return Colors.yellow;
    } else {
      return Colors.transparent;
    }
  }

  //Controls expiration text warnings on list tiles.
  String isExpired(Tracker tracker) {
    DateTime today = DateTime.now();
    final daysLeft = tracker.expDate.difference(today).inDays;
    if (daysLeft < 0) {
      print("Expired!");
      return "     EXPIRED!";
    } else if (daysLeft == 0) {
      return "     LAST DAY!";
    } else {
      print("Didn't Expire");
      return "";
    }
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

  dynamic _onSliderButtonPress(int index, Actions action, List<Tracker> list) {
    //TODO: Should I pass in the list rather than the provider?
    final user = Provider.of<TheUser?>(context, listen: false);
    final item = list[index];

    switch (action) {
      case Actions.delete:
        Tracker toRemove = list[index];
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

  //Calls detail page for tracker editing.
  void _showDetailPanel(int index) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: TrackDetPage(
              index: index,
            ),
          );
        });
  }

  void _confirmationPopup(BuildContext context, String message, Color color) {
    final popUp = SnackBar(content: Text(message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(popUp);
  }
}
