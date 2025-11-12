class Product {
  final String id;
  final String name;
  final String description;
  final double price; // This is the final selling price
  final String imageUrl;
  final String category;
  final int stock;
  final double mrp; // Maximum Retail Price

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    required this.mrp,
  });

  // A computed property for discount percentage
  double get discountPercentage {
    if (mrp <= 0 || price >= mrp) {
      return 0.0;
    }
    return ((mrp - price) / mrp) * 100;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? 'No Name',
      description: json['description'] ?? 'No Description',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? 'Uncategorized',
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      mrp: (json['mrp'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,
    );
  }
}
