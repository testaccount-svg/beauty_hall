// lib/models/product_model.dart

class ProductModel {
  final String? id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;  // lips | eyes | skin | hair | nails
  final int stock;        // остаток на складе
  final bool isAvailable;
  final String createdAt;

  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    this.isAvailable = true,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> j) => ProductModel(
        id: j['id']?.toString(),
        name: j['name'] ?? '',
        description: j['description'] ?? '',
        price: double.tryParse(j['price'].toString()) ?? 0.0,
        imageUrl: j['imageUrl'] ?? '',
        category: j['category'] ?? 'skin',
        stock: int.tryParse(j['stock'].toString()) ?? 0,
        isAvailable: j['isAvailable'] == true || j['isAvailable'] == 'true',
        createdAt: j['createdAt'] ?? DateTime.now().toIso8601String(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'category': category,
        'stock': stock,
        'isAvailable': isAvailable,
        'createdAt': createdAt,
      };

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    int? stock,
    bool? isAvailable,
    String? createdAt,
  }) =>
      ProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        category: category ?? this.category,
        stock: stock ?? this.stock,
        isAvailable: isAvailable ?? this.isAvailable,
        createdAt: createdAt ?? this.createdAt,
      );

  String get categoryLabel {
    switch (category) {
      case 'lips': return 'Губы';
      case 'eyes': return 'Глаза';
      case 'skin': return 'Уход за кожей';
      case 'hair': return 'Волосы';
      case 'nails': return 'Ногти';
      default: return 'Прочее';
    }
  }

  String get priceLabel => '${price.toStringAsFixed(0)} сом';
}
