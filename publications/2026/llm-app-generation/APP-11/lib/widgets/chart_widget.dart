import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // This is mock data. In a real application, you would get this from your service.
    final data = [
      {'day': 'Mon', 'open': 5.0, 'high': 10.0, 'low': 4.0, 'close': 9.0},
      {'day': 'Tue', 'open': 9.0, 'high': 15.0, 'low': 8.0, 'close': 13.0},
      {'day': 'Wed', 'open': 13.0, 'high': 18.0, 'low': 12.0, 'close': 17.0},
      {'day': 'Thu', 'open': 17.0, 'high': 22.0, 'low': 16.0, 'close': 20.0},
      {'day': 'Fri', 'open': 20.0, 'high': 25.0, 'low': 19.0, 'close': 24.0},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Chart(
          data: data,
          variables: {
            'day': Variable(
              accessor: (Map map) => map['day'] as String,
            ),
            'open': Variable(
              accessor: (Map map) => map['open'] as num,
            ),
            'high': Variable(
              accessor: (Map map) => map['high'] as num,
            ),
            'low': Variable(
              accessor: (Map map) => map['low'] as num,
            ),
            'close': Variable(
              accessor: (Map map) => map['close'] as num,
            ),
          },
          marks: [
            IntervalMark(
              position: Varset('day') * Varset('low+high'),
              shape: ShapeEncode(value: RectShape()),
              size: SizeEncode(value: 1),
            ),
            IntervalMark(
              position: Varset('day') * Varset('open+close'),
              shape: ShapeEncode(value: RectShape()),
              size: SizeEncode(value: 5),
              color: ColorEncode(
                  value: Colors.red,
                  updaters: {
                    'group': {
                      true: (value) => value.toString().contains('Candle') ? Colors.green : value,
                    }
                  }
              ),
            ),
          ],
          axes: [
            Defaults.horizontalAxis,
            Defaults.verticalAxis,
          ],
        ),
      ),
    );
  }
}