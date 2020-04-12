import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      // change quantity
      _items.update(
          productId,
          (ExistingCartItem) => CartItem(
                id: ExistingCartItem.id,
                title: ExistingCartItem.title,
                price: ExistingCartItem.price,
                quantity: ExistingCartItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    // remove final from in front of quantity if using this function
    if (_items.containsKey(productId)) {
      if (_items[productId].quantity > 1) {
        _items.update(
            productId,
            (ExistingItem) => CartItem(
                  id: ExistingItem.id,
                  title: ExistingItem.title,
                  price: ExistingItem.price,
                  quantity: ExistingItem.quantity - 1,
                ));
      } else {
        removeItem(productId);
      }
      notifyListeners();
    } else {
      return;
    }
  }

  void increaseQuantity(String productId) {
    // remove final from in front of quantity if using this function
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (ExistingItem) => CartItem(
                id: ExistingItem.id,
                title: ExistingItem.title,
                price: ExistingItem.price,
                quantity: ExistingItem.quantity + 1,
              ));
    } else {
      return;
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
