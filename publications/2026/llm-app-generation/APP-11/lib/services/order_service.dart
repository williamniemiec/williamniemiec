import 'dart:async';
import 'package:quantum_trade/models/order.dart';

class OrderService {
  final StreamController<Order> _orderStatusController = StreamController.broadcast();

  Stream<Order> get orderStatusStream => _orderStatusController.stream;

  void submitOrder(Order order) {
    // Simulate order submission
    _orderStatusController.add(Order(
      ticker: order.ticker,
      type: order.type,
      quantity: order.quantity,
      price: order.price,
      status: OrderStatus.submitted,
    ));

    // Simulate order fill
    Future.delayed(const Duration(seconds: 1), () {
      _orderStatusController.add(Order(
        ticker: order.ticker,
        type: order.type,
        quantity: order.quantity,
        price: order.price + 0.01, // Simulate fill price
        status: OrderStatus.filled,
      ));
    });
  }
}