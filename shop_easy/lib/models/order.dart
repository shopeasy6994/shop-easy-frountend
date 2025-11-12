import 'package:shop_easyy/models/cart_item.dart';
import 'package:shop_easyy/models/address.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> items; // Changed from 'products'
  final DateTime createdAt; // Changed from 'dateTime'
  final String status;
  final String paymentMethod;
  final Address address;
  final double redeemedCoins;

  Order({
    required this.id,
    required this.total,
    required this.items,
    required this.createdAt,
    this.status = 'Pending',
    required this.paymentMethod,
    required this.address,
    this.redeemedCoins = 0.0,
  });
}
