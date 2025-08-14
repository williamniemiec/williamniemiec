import 'package:flutter/material.dart';

class OrderBookWidget extends StatelessWidget {
  const OrderBookWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // This is mock data. In a real application, you would get this from your service.
    final bids = [
      {'price': 35.47, 'size': 100},
      {'price': 35.46, 'size': 200},
      {'price': 35.45, 'size': 300},
    ];
    final asks = [
      {'price': 35.48, 'size': 150},
      {'price': 35.49, 'size': 250},
      {'price': 35.50, 'size': 350},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text('Order Book', style: TextStyle(fontSize: 18, color: Colors.white)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('Bids', style: TextStyle(color: Colors.green)),
                Text('Asks', style: TextStyle(color: Colors.red)),
              ],
            ),
            const Divider(),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: bids.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(bids[index]['price']!.toStringAsFixed(2), style: const TextStyle(color: Colors.white)),
                            Text(bids[index]['size']!.toString(), style: const TextStyle(color: Colors.white)),
                          ],
                        );
                      },
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: asks.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(asks[index]['price']!.toStringAsFixed(2), style: const TextStyle(color: Colors.white)),
                            Text(asks[index]['size']!.toString(), style: const TextStyle(color: Colors.white)),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}