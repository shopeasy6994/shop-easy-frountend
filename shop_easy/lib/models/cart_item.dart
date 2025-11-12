import 'package:shop_easyy/models/product.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;
  final Product product;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      title: json['title'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      // The product data needs to be deserialized as well
      product: Product.fromJson(json['product']),
    );
  }
}
