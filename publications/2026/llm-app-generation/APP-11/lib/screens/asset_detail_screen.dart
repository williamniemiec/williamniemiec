import 'package:flutter/material.dart';
import 'package:quantum_trade/widgets/chart_widget.dart';
import 'package:quantum_trade/widgets/order_book_widget.dart';
import 'package:quantum_trade/widgets/trade_ticket_widget.dart';

class AssetDetailScreen extends StatelessWidget {
  final String assetTicker;

  const AssetDetailScreen({super.key, required this.assetTicker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(assetTicker),
      ),
      body: Column(
        children: const [
          Expanded(
            flex: 3,
            child: ChartWidget(),
          ),
          Expanded(
            flex: 2,
            child: OrderBookWidget(),
          ),
          Expanded(
            flex: 2,
            child: TradeTicketWidget(),
          ),
        ],
      ),
    );
  }
}