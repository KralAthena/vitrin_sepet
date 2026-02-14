class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;
  final String source; // "fake" | "dummy"

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required this.source,
  });

  // Factory for Fake Store API
  factory Product.fromJsonFakeStore(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: json['rating'] != null ? (json['rating']['rate'] as num).toDouble() : 0.0,
      source: 'fake',
    );
  }

  // Factory for DummyJSON API
  factory Product.fromJsonDummyJSON(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['thumbnail'] as String, // Use thumbnail as main image for listing
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
      source: 'dummy',
    );
  }

  // Factory for WantAPI
  factory Product.fromJsonWantApi(Map<String, dynamic> json) {
    // Price comes as "$999", need to strip '$' and parse
    String priceStr = json['price'].toString().replaceAll('\$', '').replaceAll(',', '');
    double price = double.tryParse(priceStr) ?? 0.0;

    return Product(
      id: json['id'] as int,
      title: json['name'] as String,
      price: price,
      description: json['description'] as String,
      category: 'Apple', // Default category since API doesn't provide one
      image: json['image'] as String,
      rating: 4.5, // Default rating
      source: 'want',
    );
  }
}
