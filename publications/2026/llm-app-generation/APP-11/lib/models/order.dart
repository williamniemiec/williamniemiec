enum OrderStatus {
  submitted,
  filled,
  canceled,
}

enum OrderType {
  buy,
  sell,
}

class Order {
  final String ticker;
  final OrderType type;
  final int quantity;
  final double price;
  final OrderStatus status;

  Order({
    required this.ticker,
    required this.type,
    required this.quantity,
    required this.price,
    required this.status,
  });
}