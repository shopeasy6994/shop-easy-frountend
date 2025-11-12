import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shop_easyy/api/api_client.dart';
import 'package:shop_easyy/providers/cart_provider.dart';
import 'package:shop_easyy/widgets/quantity_selector.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart (${cart.itemCount} Items)'),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) {
                      final cartItem = cart.items.values.toList()[i];
                      final imageUrl = cartItem.imageUrl.startsWith('http')
                          ? cartItem.imageUrl
                          : '${ApiClient.rootUrl}/${cartItem.imageUrl}';

                      return Dismissible(
                        key: ValueKey(cartItem.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          Provider.of<CartProvider>(context, listen: false)
                              .removeItem(cartItem.product.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    '${cartItem.title} removed from cart.')),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete,
                              color: Colors.white, size: 30),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                              title: Text(cartItem.title),
                              subtitle: Text(
                                  'Price: ₹${cartItem.price.toStringAsFixed(2)}'),
                              trailing: QuantitySelector(
                                quantity: cartItem.quantity,
                                onIncrement: () {
                                  cart.addItem(cartItem.product);
                                },
                                onDecrement: () {
                                  cart.removeSingleItem(cartItem.product.id);
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _buildCheckoutCard(context, cart),
              ],
            ),
    );
  }

  Widget _buildCheckoutCard(BuildContext context, CartProvider cart) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Total Amount',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(
                  '₹${cart.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: cart.items.isEmpty
                  ? null
                  : () {
                      // We will implement checkout screen navigation later.
                      // For now, this button is enabled if the cart is not empty.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Proceeding to Checkout...')),
                      );
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('PROCEED TO CHECKOUT'),
            )
          ],
        ),
      ),
    );
  }
}
