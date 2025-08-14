import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quantum_trade/models/order.dart';
import 'package:quantum_trade/services/order_service.dart';

class TradeTicketWidget extends StatefulWidget {
  const TradeTicketWidget({super.key});

  @override
  State<TradeTicketWidget> createState() => _TradeTicketWidgetState();
}

class _TradeTicketWidgetState extends State<TradeTicketWidget> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  String _orderType = 'Market';

  @override
  Widget build(BuildContext context) {
    final orderService = Provider.of<OrderService>(context, listen: false);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _orderType,
                items: ['Market', 'Limit'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _orderType = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Order Type'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        HapticFeedback.heavyImpact();
                        orderService.submitOrder(Order(
                          ticker: 'PETR4', // This should be dynamic
                          type: OrderType.buy,
                          quantity: int.parse(_quantityController.text),
                          price: 35.48, // This should be dynamic
                          status: OrderStatus.submitted,
                        ));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('BUY'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        HapticFeedback.heavyImpact();
                        orderService.submitOrder(Order(
                          ticker: 'PETR4', // This should be dynamic
                          type: OrderType.sell,
                          quantity: int.parse(_quantityController.text),
                          price: 35.48, // This should be dynamic
                          status: OrderStatus.submitted,
                        ));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('SELL'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}