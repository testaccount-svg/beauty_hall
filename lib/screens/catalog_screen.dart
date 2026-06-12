// lib/screens/catalog_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/shop_provider.dart';
import '../widgets/product_card.dart';
import '../models/product_model.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  static const _categories = [
    {'value': 'all',   'label': 'Все',       'icon': '✨'},
    {'value': 'skin',  'label': 'Уход',      'icon': '🧴'},
    {'value': 'lips',  'label': 'Губы',      'icon': '💄'},
    {'value': 'eyes',  'label': 'Глаза',     'icon': '👁️'},
    {'value': 'hair',  'label': 'Волосы',    'icon': '💇'},
    {'value': 'nails', 'label': 'Ногти',     'icon': '💅'},
  ];

  List<ProductModel> get _filtered {
    final provider = context.read<ShopProvider>();
    var list = provider.products;
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return list;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShopProvider>();
    final cartCount = provider.cartCount;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Шапка ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Beauty Hall',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: const Color(0xFF1E1B1D),
                          ),
                        ),
                        Text(
                          'Премиальная косметика и уход за собой',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8E7B83),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Корзина с роскошной анимацией и бейджем
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    ),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.shopping_bag_outlined,
                              color: Color(0xFF1E1B1D), size: 22),
                          if (cartCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1.5),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Center(
                                  child: Text(
                                    '$cartCount',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 8,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Промо-баннер ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4A1525),
                      Color(0xFF8E2849),
                      Color(0xFFC93D78),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC93D78).withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      bottom: -30,
                      child: Opacity(
                        opacity: 0.08,
                        child: Icon(
                          Icons.spa_rounded,
                          size: 160,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color(0xFFD4AF37).withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'ЛЕТНЯЯ КОЛЛЕКЦИЯ',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Сияние и Уход ✨',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Скидка 10% на первый заказ косметики',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Поиск ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Поиск косметики...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFFB4A6AC),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: Color(0xFF8E7B83), size: 22),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded,
                                color: Color(0xFF8E7B83), size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.black.withOpacity(0.01), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.black.withOpacity(0.01), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: primaryColor.withOpacity(0.2), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  style: GoogleFonts.plusJakartaSans(fontSize: 14, color: const Color(0xFF1E1B1D)),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Категории ─────────────────────────────────────
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (_, i) {
                  final cat = _categories[i];
                  final sel = provider.selectedCategory == cat['value'];
                  return GestureDetector(
                    onTap: () => provider.setCategory(cat['value']!),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel
                            ? primaryColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: sel ? Colors.transparent : Colors.black.withOpacity(0.04),
                          width: 1,
                        ),
                        boxShadow: sel
                            ? [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            Text(cat['icon']!, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(
                              cat['label']!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: sel
                                    ? Colors.white
                                    : const Color(0xFF1E1B1D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // ── Сетка товаров ─────────────────────────────────
            Expanded(
              child: provider.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                          color: primaryColor))
                  : _filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFF2F6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text('🔍', style: TextStyle(fontSize: 32)),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Ничего не найдено',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E1B1D),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Попробуйте изменить поисковый запрос',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: const Color(0xFF8E7B83),
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          color: primaryColor,
                          onRefresh: provider.loadProducts,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                                child: Text(
                                  'Найдено товаров: ${_filtered.length}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF8E7B83),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GridView.builder(
                                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.73,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemCount: _filtered.length,
                                  itemBuilder: (_, i) => ProductCard(
                                    product: _filtered[i],
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailScreen(
                                            product: _filtered[i]),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
