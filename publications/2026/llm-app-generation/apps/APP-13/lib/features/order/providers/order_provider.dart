import 'package:flutter/foundation.dart';
import '../../../shared/models/order.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  void setOrders(List<Order> orders) {
    _orders = orders;
    notifyListeners();
  }

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> loadOrders() async {
    setLoading(true);
    // TODO: Implement API call
    await Future.delayed(const Duration(seconds: 1));
    setLoading(false);
  }
}