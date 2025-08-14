class Trade {
  final String ticker;
  final double price;
  final int quantity;
  final DateTime timestamp;

  Trade({
    required this.ticker,
    required this.price,
    required this.quantity,
    required this.timestamp,
  });
}