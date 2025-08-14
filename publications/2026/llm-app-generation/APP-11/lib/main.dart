import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantum_trade/screens/dashboard_screen.dart';
import 'package:quantum_trade/services/market_service.dart';
import 'package:quantum_trade/services/order_service.dart';

void main() {
  runApp(const QuantumTradeApp());
}

class QuantumTradeApp extends StatelessWidget {
  const QuantumTradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => MarketService()),
        Provider(create: (_) => OrderService()),
      ],
      child: MaterialApp(
        title: 'Quantum Trade',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[900],
          cardColor: Colors.grey[850],
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
