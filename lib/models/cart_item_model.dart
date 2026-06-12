// lib/models/cart_item_model.dart
import 'product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get total => product.price * quantity;
  String get totalLabel => '${total.toStringAsFixed(0)} сом';
}
