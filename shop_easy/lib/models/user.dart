import 'package:shop_easyy/models/address.dart';

class User {
  final String id;
  final String name;
  final String email;
  final List<Address> addresses;
  final int rewardCoins;
  final String referralCode;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.addresses = const [],
    this.rewardCoins = 0,
    this.referralCode = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Defensive check for addresses list
    var addressesList = <Address>[];
    if (json['addresses'] != null && json['addresses'] is List) {
      addressesList = (json['addresses'] as List<dynamic>)
          .map((addressJson) => Address.fromJson(addressJson))
          .toList();
    }

    return User(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? 'No Name',
      email: json['email'] ?? 'No Email',
      addresses: addressesList,
      rewardCoins: (json['rewardCoins'] as num?)?.toInt() ?? 0,
      referralCode: json['referralCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'addresses': addresses.map((address) => address.toJson()).toList(),
      'rewardCoins': rewardCoins,
      'referralCode': referralCode,
    };
  }
}
