import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantum_trade/models/asset.dart';
import 'package:quantum_trade/services/market_service.dart';
import 'package:quantum_trade/screens/asset_detail_screen.dart';

class WatchlistWidget extends StatefulWidget {
  const WatchlistWidget({super.key});

  @override
  State<WatchlistWidget> createState() => _WatchlistWidgetState();
}

class _WatchlistWidgetState extends State<WatchlistWidget> {
  @override
  void initState() {
    super.initState();
    // Connect to the market service when the widget is initialized
    Provider.of<MarketService>(context, listen: false).connect();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Asset>>(
      stream: Provider.of<MarketService>(context).assetsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final assets = snapshot.data!;
        return ListView.builder(
          itemCount: assets.length,
          itemBuilder: (context, index) {
            final asset = assets[index];
            final color = asset.change > 0 ? Colors.green : Colors.red;

            return ListTile(
              title: Text(asset.ticker, style: const TextStyle(color: Colors.white)),
              trailing: Text(
                '${asset.price.toStringAsFixed(2)} (${asset.change.toStringAsFixed(2)}%)',
                style: TextStyle(color: color),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssetDetailScreen(assetTicker: asset.ticker),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}