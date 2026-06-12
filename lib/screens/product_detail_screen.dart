// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../services/shop_provider.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShopProvider>();
    final inCart = provider.isInCart(widget.product.id ?? '');
    final qty = provider.cartQuantity(widget.product.id ?? '');
    final available = widget.product.isAvailable && widget.product.stock > 0;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9FA),
      body: CustomScrollView(
        slivers: [
          // ── Пин-ап бар с параллаксом ────────────────────────
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF1E1B1D), size: 16),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
                child: Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.shopping_bag_outlined,
                          color: Color(0xFF1E1B1D), size: 18),
                      if (provider.cartCount > 0)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: widget.product.imageUrl.isNotEmpty
                  ? Hero(
                      tag: 'product-img-${widget.product.id}',
                      child: Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      ),
                    )
                  : _placeholder(),
            ),
          ),

          // ── Описание и детали ───────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFCF9FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Категория + статус наличия
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          widget.product.categoryLabel.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: available
                              ? const Color(0xFF34A853).withOpacity(0.08)
                              : const Color(0xFFEA4335).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          available
                              ? 'В НАЛИЧИИ: ${widget.product.stock} ШТ.'
                              : 'ОЖИДАЕТСЯ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: available
                                ? const Color(0xFF34A853)
                                : const Color(0xFFEA4335),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  Text(
                    widget.product.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E1B1D),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    widget.product.priceLabel,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Аккордеон деталей
                  _CollapsiblePanel(
                    title: 'Описание товара',
                    content: widget.product.description,
                    isInitiallyExpanded: true,
                  ),
                  _CollapsiblePanel(
                    title: 'Состав продукта',
                    content: 'Экстракт дамасской розы, гиалуронат натрия, растительный глицерин, пантенол, натуральные эфирные масла, родниковая альпийская вода, витаминный комплекс A-E.',
                  ),
                  _CollapsiblePanel(
                    title: 'Способ применения',
                    content: 'Равномерно нанесите небольшое количество средства на чистую кожу лица и декольте мягкими массажными движениями до полного впитывания. Использовать ежедневно утром и перед сном.',
                  ),
                  _CollapsiblePanel(
                    title: 'О бренде Beauty Hall',
                    content: 'Косметика Beauty Hall создается по инновационным формулам из экологически чистых и биоактивных ингредиентов. Наша миссия — подчеркнуть вашу естественную красоту и подарить коже безупречное здоровье и сияние.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Панель покупки внизу ────────────────────────────
      bottomNavigationBar: available
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(
                  20, 14, 20, 14 + MediaQuery.of(context).padding.bottom),
              child: inCart
                  ? Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CartScreen()),
                            ),
                            icon: Icon(Icons.shopping_bag_outlined,
                                color: primaryColor, size: 20),
                            label: Text(
                              'В КОРЗИНЕ ($qty)',
                              style: GoogleFonts.plusJakartaSans(
                                color: primaryColor,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: primaryColor, width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Кнопка быстрого добавления еще одного
                        GestureDetector(
                          onTap: () {
                            provider.addToCart(widget.product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Товар добавлен в корзину',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                duration: const Duration(seconds: 1),
                                backgroundColor: primaryColor,
                              ),
                            );
                          },
                          child: Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.add_rounded,
                                color: Colors.white, size: 26),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor,
                              primaryColor.withRed(primaryColor.red + 30),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            provider.addToCart(widget.product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Товар добавлен в корзину',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                duration: const Duration(milliseconds: 1500),
                                backgroundColor: primaryColor,
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart_checkout_rounded,
                              color: Colors.white, size: 20),
                          label: Text(
                            'ДОБАВИТЬ В КОРЗИНУ',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
            )
          : null,
    );
  }

  Widget _placeholder() => Container(
        color: const Color(0xFFFFF2F6),
        child: const Center(
          child: Icon(Icons.spa_outlined, color: Color(0xFFC93D78), size: 64),
        ),
      );
}

class _CollapsiblePanel extends StatefulWidget {
  final String title;
  final String content;
  final bool isInitiallyExpanded;

  const _CollapsiblePanel({
    required this.title,
    required this.content,
    this.isInitiallyExpanded = false,
  });

  @override
  State<_CollapsiblePanel> createState() => _CollapsiblePanelState();
}

class _CollapsiblePanelState extends State<_CollapsiblePanel> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isInitiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _expanded ? primaryColor.withOpacity(0.1) : Colors.black.withOpacity(0.02),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E1B1D),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _expanded ? primaryColor : const Color(0xFF8E7B83),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  const SizedBox(height: 12),
                  Text(
                    widget.content,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: const Color(0xFF6B7280),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
