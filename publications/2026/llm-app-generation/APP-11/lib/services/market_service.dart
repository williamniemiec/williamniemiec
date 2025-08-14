import 'dart:async';
import 'dart:convert';
import 'package:quantum_trade/models/asset.dart';
import 'package:quantum_trade/api/websocket_client.dart';

class MarketService {
  final WebSocketClient _webSocketClient = WebSocketClient();
  final StreamController<List<Asset>> _assetsController = StreamController.broadcast();

  Stream<List<Asset>> get assetsStream => _assetsController.stream;

  void connect() {
    // Replace with your actual WebSocket URL
    _webSocketClient.connect('wss://your-websocket-url.com');
    _webSocketClient.channel.stream.listen((message) {
      final data = jsonDecode(message);
      // Assuming the data is a list of assets
      final assets = (data as List).map((item) => Asset(
        ticker: item['ticker'],
        price: item['price'].toDouble(),
        change: item['change'].toDouble(),
      )).toList();
      _assetsController.add(assets);
    });
  }

  void disconnect() {
    _webSocketClient.disconnect();
  }
}