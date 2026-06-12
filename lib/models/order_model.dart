// lib/models/order_model.dart

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> j) => OrderItem(
        productId: j['productId'] ?? '',
        productName: j['productName'] ?? '',
        price: double.tryParse(j['price'].toString()) ?? 0.0,
        quantity: int.tryParse(j['quantity'].toString()) ?? 1,
        imageUrl: j['imageUrl'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'price': price,
        'quantity': quantity,
        'imageUrl': imageUrl,
      };

  double get total => price * quantity;
}

class OrderModel {
  final String? id;
  final String customerName;
  final String customerPhone;
  final String address;
  final List<OrderItem> items;
  final double totalAmount;
  final String status; // pending | confirmed | shipping | delivered | cancelled
  final String createdAt;
  final String? note;

  OrderModel({
    this.id,
    required this.customerName,
    required this.customerPhone,
    required this.address,
    required this.items,
    required this.totalAmount,
    this.status = 'pending',
    required this.createdAt,
    this.note,
  });

  factory OrderModel.fromJson(Map<String, dynamic> j) {
    final rawItems = j['items'];
    List<OrderItem> items = [];
    if (rawItems is List) {
      items = rawItems.map((e) => OrderItem.fromJson(e)).toList();
    }
    return OrderModel(
      id: j['id']?.toString(),
      customerName: j['customerName'] ?? '',
      customerPhone: j['customerPhone'] ?? '',
      address: j['address'] ?? '',
      items: items,
      totalAmount: double.tryParse(j['totalAmount'].toString()) ?? 0.0,
      status: j['status'] ?? 'pending',
      createdAt: j['createdAt'] ?? DateTime.now().toIso8601String(),
      note: j['note'],
    );
  }

  Map<String, dynamic> toJson() => {
        'customerName': customerName,
        'customerPhone': customerPhone,
        'address': address,
        'items': items.map((e) => e.toJson()).toList(),
        'totalAmount': totalAmount,
        'status': status,
        'createdAt': createdAt,
        'note': note ?? '',
      };

  String get statusLabel {
    switch (status) {
      case 'pending':   return 'Ожидает';
      case 'confirmed': return 'Подтверждён';
      case 'shipping':  return 'В доставке';
      case 'delivered': return 'Доставлен';
      case 'cancelled': return 'Отменён';
      default: return status;
    }
  }

  // Цвет статуса
  static int statusColor(String status) {
    switch (status) {
      case 'pending':   return 0xFFFBBC04;
      case 'confirmed': return 0xFF1A73E8;
      case 'shipping':  return 0xFF9C27B0;
      case 'delivered': return 0xFF34A853;
      case 'cancelled': return 0xFFEA4335;
      default: return 0xFF9CA3AF;
    }
  }

  String get totalLabel => '${totalAmount.toStringAsFixed(0)} сом';
  String get dateLabel => createdAt.split('T').first;
}
