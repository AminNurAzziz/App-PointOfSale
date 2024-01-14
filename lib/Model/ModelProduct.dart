class Product {
  final String? id;
  final String name;
  final double price;
  final int stock;
  final String? category;
  final String? imageUrl;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.category,
    this.imageUrl,
  });
}
