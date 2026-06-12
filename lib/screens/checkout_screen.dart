// lib/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/shop_provider.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<ShopProvider>();

    final order = await provider.placeOrder(
      customerName: _nameCtrl.text.trim(),
      customerPhone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      note: _noteCtrl.text.trim(),
    );

    if (order != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(orderId: order.id ?? ''),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShopProvider>();
    final cart = provider.cart;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1E1B1D), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Оформление заказа',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E1B1D),
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // ── Шаги заказа ───────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStep(1, 'Корзина', true),
                _buildStepLine(true),
                _buildStep(2, 'Доставка', true),
                _buildStepLine(false),
                _buildStep(3, 'Финиш', false),
              ],
            ),
            const SizedBox(height: 24),

            // Список товаров
            _Label('ВАШИ ТОВАРЫ'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.01),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.black.withOpacity(0.015), width: 1),
              ),
              child: Column(
                children: cart.asMap().entries.map((e) {
                  final last = e.key == cart.length - 1;
                  final item = e.value;
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        title: Text(
                          item.product.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E1B1D),
                          ),
                        ),
                        subtitle: Text(
                          'Количество: ${item.quantity} шт.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8E7B83),
                          ),
                        ),
                        trailing: Text(
                          item.totalLabel,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      if (!last)
                        const Divider(
                            height: 1, color: Color(0xFFF3F4F6), indent: 16, endIndent: 16),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            _Label('КОНТАКТНЫЕ ДАННЫЕ'),
            const SizedBox(height: 10),
            _buildCard([
              _buildField(
                ctrl: _nameCtrl,
                label: 'Имя и фамилия',
                icon: Icons.person_outline_rounded,
                validator: (v) =>
                    v?.trim().isEmpty == true ? 'Введите ваше имя' : null,
              ),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              _buildField(
                ctrl: _phoneCtrl,
                label: 'Номер телефона',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                hint: '+7 (777) 000-00-00',
                validator: (v) =>
                    v?.trim().isEmpty == true ? 'Введите номер телефона' : null,
              ),
            ]),

            const SizedBox(height: 20),

            _Label('АДРЕС ДОСТАВКИ'),
            const SizedBox(height: 10),
            _buildCard([
              _buildField(
                ctrl: _addressCtrl,
                label: 'Город, улица, дом, квартира',
                icon: Icons.location_on_outlined,
                maxLines: 2,
                validator: (v) =>
                    v?.trim().isEmpty == true ? 'Укажите адрес доставки' : null,
              ),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              _buildField(
                ctrl: _noteCtrl,
                label: 'Комментарий к заказу',
                icon: Icons.chat_bubble_outline_rounded,
                maxLines: 2,
                required: false,
              ),
            ]),

            const SizedBox(height: 24),

            // Итоговая стоимость
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.04),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: primaryColor.withOpacity(0.12),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Итого к оплате:',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E1B1D),
                    ),
                  ),
                  Text(
                    provider.cartTotalLabel,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Кнопка подтверждения
            SizedBox(
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
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : Text(
                          'ПОДТВЕРДИТЬ ЗАКАЗ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int number, String label, bool active) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active ? primaryColor : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: active ? Colors.transparent : const Color(0xFFD4AF37).withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Center(
            child: active
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                : Text(
                    '$number',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8E7B83),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: active ? const Color(0xFF1E1B1D) : const Color(0xFF8E7B83),
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool active) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 18),
      color: active ? primaryColor : Colors.grey.shade300,
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.015), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(children: children),
    );
  }

  Widget _buildField({
    required TextEditingController ctrl,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool required = true,
    String? Function(String?)? validator,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(
          color: const Color(0xFFB4A6AC),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        labelStyle: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF8E7B83),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF8E7B83), size: 20),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorStyle: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFFEA4335)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
      ),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1E1B1D),
      ),
      cursorColor: primaryColor,
      validator: validator ??
          (required
              ? (v) =>
                  v?.trim().isEmpty == true ? 'Обязательное поле' : null
              : null),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF8E7B83),
          letterSpacing: 1.0,
        ),
      );
}
