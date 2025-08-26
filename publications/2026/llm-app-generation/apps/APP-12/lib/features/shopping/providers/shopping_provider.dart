import 'package:flutter/material.dart';
import '../../../shared/models/shopping_offer.dart';

class ShoppingProvider extends ChangeNotifier {
  List<ShoppingOffer> _offers = [];
  bool _isLoading = false;
  String? _error;

  List<ShoppingOffer> get offers => _offers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setOffers(List<ShoppingOffer> offers) {
    _offers = offers;
    notifyListeners();
  }
}