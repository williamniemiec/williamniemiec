import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantum_trade/models/order.dart';
import 'package:quantum_trade/services/order_service.dart';
import 'package:quantum_trade/widgets/watchlist_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrderService>(context, listen: false)
        .orderStatusStream
        .listen((order) {
      final snackBar = SnackBar(
        content: Text(
            '${order.status.toString().split('.').last.toUpperCase()}: ${order.type.toString().split('.').last.toUpperCase()} ${order.quantity} ${order.ticker} @ ${order.price.toStringAsFixed(2)}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quantum Trade'),
      ),
      body: const WatchlistWidget(),
    );
  }
}