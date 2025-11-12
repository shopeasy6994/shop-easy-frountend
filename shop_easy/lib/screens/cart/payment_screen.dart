import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easyy/providers/cart_provider.dart';
import 'package:shop_easyy/providers/order_provider.dart';
import 'package:shop_easyy/models/address.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  Future<void> _submitOrder(BuildContext context) async {
    // Get providers, no need to listen here
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // Placeholder for selected address - in a real app, this would be passed in
    final tempAddress = Address(
        id: '1',
        street: '123 Main St',
        city: 'Dev City',
        state: 'FL',
        postalCode: '12345',
        country: 'USA');

    final success = await orderProvider.placeOrder(
      cartProvider: cartProvider,
      address: tempAddress,
    );

    // Check if the widget is still in the tree before using context
    if (!context.mounted) return;

    if (success) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(orderProvider.errorMessage ?? 'Could not place order.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Center(
        child: Consumer<OrderProvider>(
          builder: (ctx, orderProvider, _) => orderProvider.isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () => _submitOrder(context),
                  child: const Text('Confirm Payment (Cash on Delivery)'),
                ),
        ),
      ),
    );
  }
}
