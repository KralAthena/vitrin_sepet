import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartStore {
  // Singleton instance
  static final CartStore _instance = CartStore._internal();

  factory CartStore() {
    return _instance;
  }

  CartStore._internal();

  // ValueNotifier for reactive UI
  final ValueNotifier<Map<String, CartItem>> cartNotifier = ValueNotifier({});

  Map<String, CartItem> get _currentCart => cartNotifier.value;

  String _getKey(Product product) => '${product.source}_${product.id}';

  void addToCart(Product product) {
    final key = _getKey(product);
    final newCart = Map<String, CartItem>.from(_currentCart);

    if (newCart.containsKey(key)) {
      newCart[key]!.quantity++;
    } else {
      newCart[key] = CartItem(product: product);
    }
    
    cartNotifier.value = newCart;
  }

  void removeFromCart(Product product) {
    final key = _getKey(product);
    if (!_currentCart.containsKey(key)) return;

    final newCart = Map<String, CartItem>.from(_currentCart);
    newCart.remove(key);
    cartNotifier.value = newCart;
  }

  void incrementQuantity(Product product) {
    addToCart(product);
  }

  void decrementQuantity(Product product) {
    final key = _getKey(product);
    if (!_currentCart.containsKey(key)) return;

    final newCart = Map<String, CartItem>.from(_currentCart);
    if (newCart[key]!.quantity > 1) {
      newCart[key]!.quantity--;
      cartNotifier.value = newCart;
    } else {
      removeFromCart(product);
    }
  }
  
  void deleteItem(Product product) {
    removeFromCart(product);
  }

  void clearCart() {
    cartNotifier.value = {};
  }

  int get totalItems {
    int total = 0;
    for (var item in _currentCart.values) {
      total += item.quantity;
    }
    return total;
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in _currentCart.values) {
      total += item.totalPrice;
    }
    return total;
  }
}
