import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_easyy/providers/cart_provider.dart';
import 'package:shop_easyy/screens/cart/payment_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Shipping Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Placeholder for address selection
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('John Doe\n123 Flutter Lane\nDev City, 12345'),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Order Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal:'),
                        Text('₹${cart.totalAmount.toStringAsFixed(2)}'),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping:'),
                        Text('FREE'),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('₹${cart.totalAmount.toStringAsFixed(2)}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const PaymentScreen()),
                );
              },
              child: const Text('Proceed to Payment'),
            )
          ],
        ),
      ),
    );
  }
}
