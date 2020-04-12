import 'package:flutter/foundation.dart';

enum Categories {
  Clothing,
  Kitchen,
  Home,
  Electronics,
  Kids,
  Uncategorized,
}

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final Categories category;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    @required this.category,
    this.isFavourite = false,
  });

  void toggleFavouriteStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
