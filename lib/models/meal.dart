import 'package:capstone_app/models/listItem.dart';

class Meal {
  final String name;
  final List<ListItem>? ingredients;

  Meal({required this.name, this.ingredients});

  String toString() => this.name;

//Prepare to be sent to Firestore.
  Map<String, dynamic>? toMap() {
    return {'name': this.name, 'ingredients': mapIngredients()};
  }

  List<Map<String, dynamic>?> mapIngredients() {
    List<Map<String, dynamic>?> newList = [];
    if (this.ingredients != null) {
      this.ingredients!.forEach((element) {
        newList.add(element.toMap());
      });
    }
    return newList;
  }
}
