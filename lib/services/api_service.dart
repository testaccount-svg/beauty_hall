// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class ApiService {
  static final ApiService _i = ApiService._();
  factory ApiService() => _i;
  ApiService._();

  final _headers = {'Content-Type': 'application/json'};

  static final List<ProductModel> _fallbackProducts = [
    ProductModel(
      id: 'fb-skin-1',
      name: 'Сыворотка с гиалуроновой кислотой',
      description: 'Интенсивное увлажнение и сияние вашей кожи на 24 часа. Содержит 2% чистой гиалуроновой кислоты и провитамин B5 для глубокого восстановления естественного баланса влаги.',
      price: 1200,
      imageUrl: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=600&q=80',
      category: 'skin',
      stock: 15,
      isAvailable: true,
      createdAt: DateTime.now().toIso8601String(),
    ),
    ProductModel(
      id: 'fb-skin-2',
      name: 'Освежающий тоник с экстрактом розы',
      description: 'Деликатно очищает, тонизирует и мгновенно восстанавливает pH-баланс кожи. Дарит ощущение свежести и легкий аромат свежесрезанных дамасских роз.',
      price: 850,
      imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c80836?w=600&q=80',
      category: 'skin',
      stock: 8,
      isAvailable: true,
      createdAt: DateTime.now().toIso8601String(),
    ),
    ProductModel(
      id: 'fb-lips-1',
      name: 'Увлажняющее масло Honey Glow',
      description: 'Питательная формула с экстрактом натурального меда и масла жожоба. Придает губам роскошный глянцевый блеск без ощущения липкости, разглаживает мелкие морщинки.',
      price: 650,
      imageUrl: 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=600&q=80',
      category: 'lips',
      stock: 20,
      isAvailable: true,
      createdAt: DateTime.now().toIso8601String(),
    ),
    ProductModel(
      id: 'fb-lips-2',
      name: 'Матовая помада Velvet Rose',
      description: 'Изысканный пудровый финиш и невероятная стойкость до 12 часов. Благодаря кремовой текстуре и маслу ши в составе, помада не сушит нежную кожу губ.',
      price: 900,
      imageUrl: 'https://images.unsplash.com/photo-1599733589046-10c005739ef9?w=600&q=80',
      category: 'lips',
      stock: 12,
      isAvailable: true,
      createdAt: DateTime.now().toIso8601String(),
    ),
    ProductModel(
      id: 'fb-eyes-1',
      name: 'Палетка теней Nude & Gold',
      description: '12 роскошных высокопигментированных оттенков от нежных матовых до сияющих золотых шиммеров. Легко тушуются, не осыпаются и держатся в течение всего дня.',
      price: 1500,
      imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=600&q=80',
      category: 'eyes',
      stock: 5,
      isAvailable: true,
      createdAt: DateTime.now().toIso8601String(),
    ),
    ProductModel(
      id: 'fb-eyes-2',
      name: 'Объемная тушь Royal Volume',
      description: 'Угольно-черный пигмент и силиконовая щеточка создают эффект невероятных накладных ресниц. Подкручивает, разделяет и увеличивает объем в 5 раз.',
      price: 700,
      imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=600&q=80',
      category: 'eyes',
      stock: 18,
      isAvailable: true,
      createdAt: DateTime.now().toIso8601String(),
    ),
    ProductModel(
      id: 'fb-hair-1',
      name: 'Аргановое масло-эликсир для волос',
      description: 'Эликсир на основе натурального марокканского арганового масла. Глубоко питает поврежденную структуру волос, предотвращает сечение кончиков и облегчает укладку.',
      price: 1400,
      imageUrl: 'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=600&q=80',
      category: 'hair',
      stock: 14,
      isAvailable: true,
      createdAt: DateTime.now().toIso8601String(),
    ),
    ProductModel(
      id: 'fb-hair-2',
      name: 'Бессульфатный шампунь Keratin Care',
      description: 'Деликатное очищение кожи головы и защита кератинового слоя волос. Не содержит парабенов и сульфатов, идеально подходит после процедур выпрямления и окрашивания.',
      price: 800,
      imageUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&q=80',
      category: 'hair',
      stock: 25,
      isAvailable: true,
      createdAt: DateTime.now().toIso8601String(),
    ),
    ProductModel(
      id: 'fb-nails-1',
      name: 'Масло для кутикулы Lemon Active',
      description: 'Профессиональное средство для ухода за ногтевой пластиной и кутикулой с приятным цитрусовым ароматом. Быстро впитывается и придает рукам салонный вид.',
      price: 400,
      imageUrl: 'https://images.unsplash.com/photo-1607606327832-8ef34845cfa8?w=600&q=80',
      category: 'nails',
      stock: 30,
      isAvailable: true,
      createdAt: DateTime.now().toIso8601String(),
    ),
    ProductModel(
      id: 'fb-nails-2',
      name: 'Гель-лак Gel Effect Longwear',
      description: 'Революционный лак для ногтей с эффектом гелевого покрытия без УФ-лампы. Обеспечивает насыщенный глянцевый цвет и стойкость до 7-10 дней.',
      price: 350,
      imageUrl: 'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=600&q=80',
      category: 'nails',
      stock: 40,
      isAvailable: true,
      createdAt: DateTime.now().toIso8601String(),
    ),
  ];

  // ─── PRODUCTS ─────────────────────────────────────────────

  Future<List<ProductModel>> getProducts() async {
    List<ProductModel> apiProducts = [];
    try {
      final res = await http
          .get(Uri.parse(AppConfig.productsEndpoint), headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        if (data.isNotEmpty) {
          apiProducts = data.map((e) => ProductModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print('[API] getProducts: $e');
    }
    final combined = [...apiProducts, ..._fallbackProducts];
    combined.shuffle();
    return combined;
  }

  Future<ProductModel?> createProduct(ProductModel p) async {
    try {
      final res = await http
          .post(Uri.parse(AppConfig.productsEndpoint), headers: _headers, body: jsonEncode(p.toJson()))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 201) return ProductModel.fromJson(jsonDecode(res.body));
    } catch (e) { print('[API] createProduct: $e'); }
    return null;
  }

  Future<ProductModel?> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final res = await http
          .put(Uri.parse('${AppConfig.productsEndpoint}/$id'), headers: _headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) return ProductModel.fromJson(jsonDecode(res.body));
    } catch (e) { print('[API] updateProduct: $e'); }
    return null;
  }

  Future<bool> deleteProduct(String id) async {
    try {
      final res = await http
          .delete(Uri.parse('${AppConfig.productsEndpoint}/$id'), headers: _headers)
          .timeout(const Duration(seconds: 10));
      return res.statusCode == 200;
    } catch (e) { print('[API] deleteProduct: $e'); return false; }
  }

  // ─── ORDERS ───────────────────────────────────────────────

  Future<List<OrderModel>> getOrders() async {
    try {
      final res = await http
          .get(Uri.parse(AppConfig.ordersEndpoint), headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => OrderModel.fromJson(e)).toList();
      }
    } catch (e) { print('[API] getOrders: $e'); }
    return [];
  }

  Future<OrderModel?> createOrder(OrderModel o) async {
    try {
      final res = await http
          .post(Uri.parse(AppConfig.ordersEndpoint), headers: _headers, body: jsonEncode(o.toJson()))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 201) return OrderModel.fromJson(jsonDecode(res.body));
    } catch (e) { print('[API] createOrder: $e'); }
    return null;
  }

  Future<OrderModel?> updateOrderStatus(String id, String status) async {
    try {
      final res = await http
          .put(Uri.parse('${AppConfig.ordersEndpoint}/$id'), headers: _headers, body: jsonEncode({'status': status}))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) return OrderModel.fromJson(jsonDecode(res.body));
    } catch (e) { print('[API] updateOrderStatus: $e'); }
    return null;
  }

  Future<bool> deleteOrder(String id) async {
    try {
      final res = await http
          .delete(Uri.parse('${AppConfig.ordersEndpoint}/$id'), headers: _headers)
          .timeout(const Duration(seconds: 10));
      return res.statusCode == 200;
    } catch (e) { print('[API] deleteOrder: $e'); return false; }
  }
}
