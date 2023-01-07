import 'dart:io';

import 'package:capstone_app/models/listItem.dart';
import 'package:capstone_app/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone_app/models/user.dart';

import '../models/meal.dart';
import '../models/tracker.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  //collection references.

  final CollectionReference listDoc =
      FirebaseFirestore.instance.collection('lists');

  final CollectionReference mealsDoc =
      FirebaseFirestore.instance.collection('meals');

  final CollectionReference eventsDoc =
      FirebaseFirestore.instance.collection('calendars');

  final CollectionReference trackDoc =
      FirebaseFirestore.instance.collection('trackers');

  // List<ListItem> dummy = [(ListItem(name: 'example', quantity: '1'))];

  Future updateUserData([List<ListItem>? newList, ListItem? newestItem]) async {
    if (newestItem != null) {
      newList!.add(newestItem);
    }
    return await listDoc
        .doc(uid)
        .set({'list': listToMapList(newList)}); //?? listToMap(dummy)});
  }

  Future updateMeals([List<Meal>? newList]) async {
    return await mealsDoc
        .doc(uid)
        .set({'list': mealListToMapList(newList)}); //?? listToMap(dummy)});
  }

  Future updateTrackers([List<Tracker>? newList]) async {
    return await trackDoc
        .doc(uid)
        .set({'list': listToMapList(newList)}); //?? listToMap(dummy)});
  }

  Future updateListItem(ListItem updatedItem, ListItem oldItem) async {
    // await listDoc.doc(uid).update({
    //   "list": FieldValue.arrayRemove(list[index])
    // });
    // return await listDoc.doc(uid).update({
    //   "list": FieldValue.arrayUnion([(listItemToMap(updatedItem))])
    // });
    await deleteFromList(oldItem);
    // sleep(Duration(seconds: 5));
    return await addToList(updatedItem);
  }

  Map<String, dynamic>? listToMap(List<ListItem>? newList) {
    Map<String, dynamic> map = Map.fromIterable(newList!,
        key: (e) => e.name,
        value: (e) => {
              'isChecked': e.isChecked,
              'name': e.name,
              'category': e.category,
              'quantity': e.quantity,
              'packSize': e.packSize,
              'store': e.store,
              'notes': e.notes
            });
    return map;
  }

  // Map<String, dynamic> listItemToMap(ListItem? item) {
  //   Map<String, dynamic> map = {
  //     'isChecked': item!.isChecked,
  //     'name': item!.name,
  //     'category': item!.category,
  //     'quantity': item!.quantity,
  //     'packSize': item!.packSize,
  //     'store': item!.store,
  //     'notes': item!.notes
  //   };
  //   return map;
  // }

  List<Map<String, dynamic>?> listToMapList(List<dynamic>? newList) {
    if (newList != null) {
      List<Map<String, dynamic>?> list = [];
      newList.forEach((item) {
        list.add(item.toMap());
      });
      return list;
    }
    return [];
  }

  List<Map<String, dynamic>?> mealListToMapList(List<Meal>? newList) {
    if (newList != null) {
      List<Map<String, dynamic>?> list = [];
      newList.forEach((item) {
        list.add(item.toMap());
      });
      return list;
    }
    return [];
  }

  List<ListItem> _itemListFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> theList = snapshot.get('list');
    List<ListItem> newList = [];

    theList.forEach(((item) {
      ListItem x = ListItem(
          isChecked: item['isChecked'] ?? false,
          name: item['name'] ?? 'noName',
          category: item['category'] ?? null,
          quantity: item['quantity'] ?? '0',
          packSize: item['packSize'] ?? null,
          store: item['store'] ?? null,
          notes: item['notes'] ?? null);
      newList.add(x);
    }));

    return newList;
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      //Must have uid
      uid: uid,
      list: _itemListFromSnapshot(snapshot),
      // list: []
    );
  }

  //Meals from snapshot
  List<Meal> _MealsFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> theList = snapshot.get('list');
    List<Meal> newList = [];

    theList.forEach(((item) {
      Meal x = Meal(
          name: item['name'] ?? 'NoName',
          ingredients: itemListFromMap(item['ingredients']) ?? []);
      newList.add(x);
    }));

    return newList;
  }

  //Events from snapshot.. Coming soon..
  // List<CalEvent> _EventsFromSnapshot(DocumentSnapshot snapshot) {
  //   List<dynamic> theList = snapshot.get('list');
  //   List<CalEvent> newList = [];

  //   theList.forEach(((item) {
  //     ListItem x = ListItem(
  //         isChecked: item['isChecked'] ?? false,
  //         name: item['name'] ?? 'noName',
  //         category: item['category'] ?? null,
  //         quantity: item['quantity'] ?? '0',
  //         packSize: item['packSize'] ?? null,
  //         store: item['store'] ?? null,
  //         notes: item['notes'] ?? null);
  //     newList.add(x);
  //   }));

  //   return newList;
  // }

  //userData from snapshot
  List<Tracker> _TrackersFromSnapshot(DocumentSnapshot snapshot) {
    List<dynamic> theList = snapshot.get('list');
    List<Tracker> newList = [];

    theList.forEach(((item) {
      Tracker x = Tracker(
        name: item['name'] ?? null,
        expDate: item['expDate'].toDate() ?? null,
      );
      newList.add(x);
    }));

    return newList;
  }

  List<ListItem> itemListFromMap(List<dynamic> map) {
    List<ListItem> newList = [];

    map.forEach(((item) {
      ListItem x = ListItem(
          isChecked: item['isChecked'] ?? false,
          name: item['name'] ?? 'noName',
          category: item['category'] ?? null,
          quantity: item['quantity'] ?? '0',
          packSize: item['packSize'] ?? null,
          store: item['store'] ?? null,
          notes: item['notes'] ?? null);
      newList.add(x);
    }));

    return newList;
  }

//Getters
  //get list stream
  Stream<List<ListItem>> get list {
    // var q = listDoc.doc(uid).snapshots().;
    // print("UID: $uid");
    return listDoc.doc(uid).snapshots().map(_itemListFromSnapshot);
    // return listDoc.snapshots().map(_itemListFromSnapshot);
  }

  //get user List stream
  Stream<UserData> get userData {
    // return listCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
    return listDoc.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //get user meal stream
  Stream<List<Meal>> get meals {
    // return listCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
    return mealsDoc.doc(uid).snapshots().map(_MealsFromSnapshot);
  }

  //get user event stream
  // Stream<List<CalEvent>> get events {
  //   // return listCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  //   return eventsDoc.doc(uid).snapshots().map(_EventsFromSnapshot);
  // }

  //get user tracker stream
  Stream<List<Tracker>> get trackers {
    // return listCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
    return trackDoc.doc(uid).snapshots().map(_TrackersFromSnapshot);
  }

  //add to existing DB list
  Future addToList(dynamic newItem) async {
    return await listDoc.doc(uid).update({
      "list": FieldValue.arrayUnion([newItem.toMap()])
    });
  }

  //delete item from existing DB list
  Future deleteFromList(dynamic theItem) async {
    return await listDoc.doc(uid).update({
      "list": FieldValue.arrayRemove([theItem.toMap()])
    }).onError((error, stackTrace) => print(error));
  }
}
