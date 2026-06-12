// lib/services/shop_provider.dart
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import 'api_service.dart';

class ShopProvider extends ChangeNotifier {
  final _api = ApiService();

  List<ProductModel> _products = [];
  final List<CartItem> _cart = [];
  bool _loading = false;
  String? _error;
  String _selectedCategory = 'all';

  bool get isLoading => _loading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  List<CartItem> get cart => _cart;

  List<ProductModel> get products {
    if (_selectedCategory == 'all') return _products;
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  int get cartCount => _cart.fold(0, (sum, i) => sum + i.quantity);
  double get cartTotal => _cart.fold(0.0, (sum, i) => sum + i.total);
  String get cartTotalLabel => '${cartTotal.toStringAsFixed(0)} сом';

  bool isInCart(String productId) =>
      _cart.any((i) => i.product.id == productId);

  int cartQuantity(String productId) {
    try {
      return _cart.firstWhere((i) => i.product.id == productId).quantity;
    } catch (_) {
      return 0;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadProducts() async {
    _setLoading(true);
    try {
      _products = await _api.getProducts();
    } catch (e) {
      _error = 'Ошибка загрузки товаров';
    } finally {
      _setLoading(false);
    }
  }

  // ─── Корзина ──────────────────────────────────────────────

  void addToCart(ProductModel product) {
    final idx = _cart.indexWhere((i) => i.product.id == product.id);
    if (idx >= 0) {
      if (_cart[idx].quantity < product.stock) _cart[idx].quantity++;
    } else {
      _cart.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    final idx = _cart.indexWhere((i) => i.product.id == productId);
    if (idx >= 0) {
      if (_cart[idx].quantity > 1) {
        _cart[idx].quantity--;
      } else {
        _cart.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // ─── Оформление заказа ────────────────────────────────────

  Future<OrderModel?> placeOrder({
    required String customerName,
    required String customerPhone,
    required String address,
    String? note,
  }) async {
    if (_cart.isEmpty) return null;
    _setLoading(true);
    try {
      final items = _cart
          .map((i) => OrderItem(
                productId: i.product.id ?? '',
                productName: i.product.name,
                price: i.product.price,
                quantity: i.quantity,
                imageUrl: i.product.imageUrl,
              ))
          .toList();

      final order = OrderModel(
        customerName: customerName,
        customerPhone: customerPhone,
        address: address,
        items: items,
        totalAmount: cartTotal,
        status: 'pending',
        createdAt: DateTime.now().toIso8601String(),
        note: note,
      );

      final created = await _api.createOrder(order);
      if (created != null) {
        clearCart();
        return created;
      }
    } catch (e) {
      _error = 'Ошибка оформления заказа';
    } finally {
      _setLoading(false);
    }
    return null;
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
