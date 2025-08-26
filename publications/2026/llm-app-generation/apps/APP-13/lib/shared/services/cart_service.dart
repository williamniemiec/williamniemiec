import 'package:flutter/foundation.dart';
import '../models/cart.dart';
import '../models/cookie.dart';

class CartService extends ChangeNotifier {
  Cart _cart = const Cart();

  Cart get cart => _cart;

  void addItem(Cookie cookie, {int quantity = 1}) {
    _cart = _cart.addItem(cookie, quantity: quantity);
    notifyListeners();
  }

  void removeItem(String cookieId) {
    _cart = _cart.removeItem(cookieId);
    notifyListeners();
  }

  void updateItemQuantity(String cookieId, int quantity) {
    _cart = _cart.updateItemQuantity(cookieId, quantity);
    notifyListeners();
  }

  void setBoxSize(BoxSize boxSize) {
    _cart = _cart.setBoxSize(boxSize);
    notifyListeners();
  }

  void applyPromoCode(String code, double discount) {
    _cart = _cart.applyPromoCode(code, discount);
    notifyListeners();
  }

  void clearCart() {
    _cart = _cart.clear();
    notifyListeners();
  }
}