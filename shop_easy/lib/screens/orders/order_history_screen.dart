import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easyy/providers/order_provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrderProvider>(context, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: Consumer<OrderProvider>(
        builder: (ctx, orderData, child) {
          if (orderData.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (orderData.orders.isEmpty) {
            return const Center(child: Text('You have no orders yet.'));
          }
          return ListView.builder(
            itemCount: orderData.orders.length,
            itemBuilder: (ctx, i) => Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('Order ID: ${orderData.orders[i].id}'),
                subtitle: Text(
                    'Total: ₹${orderData.orders[i].total.toStringAsFixed(2)}'),
                trailing: Text(orderData.orders[i].status),
              ),
            ),
          );
        },
      ),
    );
  }
}
