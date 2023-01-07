import 'package:capstone_app/models/listItem.dart';

class TheUser {
  final String uid;

  TheUser({required this.uid});
}

class UserData {
  final String uid;
  final List<ListItem> list;

  UserData({required this.uid, required this.list});
}
