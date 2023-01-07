class ListItem {
  bool isChecked;
  final String? name;
  final String? category;
  final String? quantity;
  final String? packSize;
  final String? store;
  final String? notes;

  ListItem(
      {this.isChecked = false,
      required this.name,
      this.category,
      this.quantity,
      this.packSize,
      this.store,
      this.notes});

//Prep the object for Firestore.
  Map<String, dynamic>? toMap() {
    return {
      'name': this.name,
      'category': this.category,
      'quantity': this.quantity,
      'packSize': this.packSize,
      'store': this.store,
      'notes': this.notes,
      'isChecked': this.isChecked
    };
  }

// Copy needed to copy but have different hashcode
  ListItem copy() {
    return ListItem(
        name: this.name,
        category: this.category,
        quantity: this.quantity,
        packSize: this.packSize,
        store: this.store,
        notes: this.notes,
        isChecked: this.isChecked);
  }
}
