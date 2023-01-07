class Tracker {
  final String name;
  DateTime expDate;

  Tracker({required this.name, required this.expDate});

  String toString() => this.name;

//Prep for Firestore.
  Map<String, dynamic>? toMap() {
    return {'name': this.name, 'expDate': this.expDate};
  }
}
