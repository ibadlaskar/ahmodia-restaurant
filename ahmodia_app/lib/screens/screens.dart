// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../providers/cart_provider.dart';
import '../widgets/widgets.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────
// MAIN SHELL  (Bottom Nav + Pages)
// ─────────────────────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override State<MainShell> createState() => _MainShellState();
}
class _MainShellState extends State<MainShell> {
  int _idx = 0;
  final _pages = const [HomeScreen(), TrackScreen(), ProfileScreen(), CartScreen()];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      body: _pages[_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu_rounded), label: 'Menu'),
          const BottomNavigationBarItem(icon: Icon(Icons.location_on_rounded), label: 'Track'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: cart.itemCount > 0,
              label: Text('${cart.itemCount}'),
              child: const Icon(Icons.shopping_cart_rounded)),
            label: 'Cart'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// HOME / MENU SCREEN
// ─────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  String _selectedCat = 'All';
  final _cats = ['All','Rice Pack','Thali','Curry','Sides','Drinks'];
  final _catEmojis = {'All':'🍽️','Rice Pack':'🍚','Thali':'🥘','Curry':'🍲','Sides':'🥗','Drinks':'🥤'};

  List<MenuItem> get _filtered => _selectedCat == 'All'
      ? AppData.menu
      : AppData.menu.where((i) => i.category == _selectedCat).toList();

  void _openPackModal(MenuItem item) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PackBuilderSheet(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        // Hero AppBar
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: AppColors.green,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.green, Color(0xFF1A3A2A)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.saffron.withOpacity(0.2),
                      border: Border.all(color: AppColors.saffron2.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(99)),
                    child: Text('🌿 Fresh Home-Style Meals Daily',
                      style: GoogleFonts.nunito(
                        fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.saffron2)),
                  ),
                  const SizedBox(height: 10),
                  Text('Wholesome Meals,\nDelivered Warm 🍛',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.white)),
                ]),
              ),
            ),
          ),
          title: Row(children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: AppColors.saffron, borderRadius: BorderRadius.circular(8)),
              child: const Center(child: Text('🍛', style: TextStyle(fontSize: 16)))),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Ahmodia', style: GoogleFonts.playfairDisplay(
                fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.white)),
              Text('RESTAURANT', style: GoogleFonts.nunito(
                fontSize: 9, color: AppColors.white.withOpacity(0.6), letterSpacing: 1)),
            ]),
          ]),
        ),

        SliverToBoxAdapter(child: Column(children: [
          // Delivery Banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF8E1), Color(0xFFFFF3CD)],
                begin: Alignment.centerLeft, end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.saffron2.withOpacity(0.3))),
            child: Row(children: [
              const Text('🏍️', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Free Delivery on orders above ₹250',
                  style: GoogleFonts.nunito(
                    fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.saffron)),
                Text('Only ₹30 delivery charge below that',
                  style: GoogleFonts.nunito(fontSize: 12, color: AppColors.mid)),
              ])),
            ]),
          ),

          // Category Chips
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _cats.length,
              itemBuilder: (_, i) {
                final cat = _cats[i];
                final isSelected = cat == _selectedCat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCat = cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.green : AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.green : AppColors.cream3,
                        width: 2)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(_catEmojis[cat] ?? '', style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 4),
                      Text(cat, style: GoogleFonts.nunito(
                        fontSize: 11, fontWeight: FontWeight.w700,
                        color: isSelected ? AppColors.white : AppColors.gray)),
                    ]),
                  ),
                );
              },
            ),
          ),
        ])),

        // Menu Grid/List
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(delegate: SliverChildBuilderDelegate((ctx, i) {
            // Rice Packs section
            final packs = _filtered.where((m) => m.isPack).toList();
            final others = _filtered.where((m) => !m.isPack).toList();

            if (i == 0 && packs.isNotEmpty) {
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SectionTitle(title: '🍚 Rice Packs', subtitle: '— customise with add-ons'),
                GridView.builder(
                  shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 12,
                    mainAxisSpacing: 12, childAspectRatio: 0.75),
                  itemCount: packs.length,
                  itemBuilder: (_, j) => PackCard(
                    item: packs[j],
                    onTap: () => _openPackModal(packs[j])),
                ),
              ]);
            }
            final idx = i - (packs.isNotEmpty ? 1 : 0);
            if (idx < 0 || idx >= others.length) return const SizedBox.shrink();
            final item = others[idx];
            if (idx == 0 && packs.isNotEmpty) {
              // section header for thalis/curries
            }
            return ComboCard(
              item: item,
              onAdd: () {
                context.read<CartProvider>().addDirectItem(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.emoji} ${item.name} added!'),
                    backgroundColor: AppColors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    duration: const Duration(seconds: 2),
                  ));
              },
            );
          }, childCount: 1 + _filtered.where((m) => !m.isPack).length)),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PACK BUILDER BOTTOM SHEET
// ─────────────────────────────────────────────────────────────
class PackBuilderSheet extends StatefulWidget {
  final MenuItem item;
  const PackBuilderSheet({super.key, required this.item});
  @override State<PackBuilderSheet> createState() => _PackBuilderSheetState();
}
class _PackBuilderSheetState extends State<PackBuilderSheet> {
  String _size = 'Half';
  final Set<String> _selectedAddons = {};

  double get _ricePrice => _size == 'Half' ? 80 : 130;
  double get _addonsTotal => AppData.addons
    .where((a) => _selectedAddons.contains(a.id))
    .fold(0, (s, a) => s + a.price);
  double get _total => _ricePrice + _addonsTotal;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9, maxChildSize: 0.95, minChildSize: 0.5,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(children: [
          // Handle
          Container(
            width: 40, height: 4, margin: const EdgeInsets.only(top: 12, bottom: 4),
            decoration: BoxDecoration(
              color: AppColors.cream3, borderRadius: BorderRadius.circular(2))),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Build Your Pack 🍛',
                style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w700)),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(backgroundColor: AppColors.xlgray)),
            ]),
          ),
          Expanded(child: SingleChildScrollView(
            controller: ctrl,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Size picker
              Text('Choose Size', style: GoogleFonts.nunito(
                fontSize: 11, fontWeight: FontWeight.w800,
                color: AppColors.gray, letterSpacing: 0.8)),
              const SizedBox(height: 10),
              Row(children: [
                _sizeOption('Half', '🍚', '~300g Rice', '₹80'),
                const SizedBox(width: 12),
                _sizeOption('Full', '🍛', '~500g Rice', '₹130'),
              ]),
              const SizedBox(height: 20),
              // Addons
              Text('Add Items (Optional)', style: GoogleFonts.nunito(
                fontSize: 11, fontWeight: FontWeight.w800,
                color: AppColors.gray, letterSpacing: 0.8)),
              const SizedBox(height: 10),
              ...AppData.addons.map((addon) {
                final checked = _selectedAddons.contains(addon.id);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (checked) _selectedAddons.remove(addon.id);
                    else _selectedAddons.add(addon.id);
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    decoration: BoxDecoration(
                      color: checked ? AppColors.greenLight : AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: checked ? AppColors.green3 : AppColors.cream3,
                        width: 1.5)),
                    child: Row(children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22, height: 22,
                        decoration: BoxDecoration(
                          color: checked ? AppColors.green : AppColors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: checked ? AppColors.green : AppColors.lgray,
                            width: 2)),
                        child: checked
                          ? const Icon(Icons.check, size: 14, color: AppColors.white)
                          : null,
                      ),
                      const SizedBox(width: 12),
                      Text(addon.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(addon.name, style: GoogleFonts.nunito(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                        Text(addon.description, style: GoogleFonts.nunito(
                          fontSize: 11, color: AppColors.gray)),
                      ])),
                      Text('+₹${addon.price.toStringAsFixed(0)}',
                        style: GoogleFonts.nunito(
                          fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.green)),
                    ]),
                  ),
                );
              }),
              const SizedBox(height: 100), // space for footer
            ]),
          )),
          // Footer
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.cream3))),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Total', style: GoogleFonts.nunito(fontSize: 13, color: AppColors.gray)),
                Text('₹${_total.toStringAsFixed(0)}',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.green)),
              ]),
              const SizedBox(width: 20),
              Expanded(child: ElevatedButton(
                onPressed: () {
                  final selectedAddonsList = AppData.addons
                    .where((a) => _selectedAddons.contains(a.id)).toList();
                  context.read<CartProvider>().addPackItem(
                    name: widget.item.name,
                    emoji: widget.item.emoji,
                    size: _size,
                    selectedAddons: selectedAddonsList,
                    ricePrice: _ricePrice,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('$_size Rice Pack added to cart!'),
                    backgroundColor: AppColors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ));
                },
                child: const Text('🛒  Add to Cart'),
              )),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _sizeOption(String size, String emoji, String sub, String price) {
    final selected = _size == size;
    return Expanded(child: GestureDetector(
      onTap: () => setState(() => _size = size),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.greenLight : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.green : AppColors.cream3,
            width: 2)),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(size, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800)),
          Text(sub, style: GoogleFonts.nunito(fontSize: 11, color: AppColors.gray)),
          const SizedBox(height: 4),
          Text(price, style: GoogleFonts.playfairDisplay(
            fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.green)),
        ]),
      ),
    ));
  }
}

// ─────────────────────────────────────────────────────────────
// CART SCREEN
// ─────────────────────────────────────────────────────────────
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart 🛒'),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, cart),
              child: Text('Clear', style: GoogleFonts.nunito(
                color: AppColors.white, fontWeight: FontWeight.w700))),
        ],
      ),
      body: cart.items.isEmpty
        ? _emptyCart(context)
        : Column(children: [
            Expanded(child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...cart.items.map((item) => _cartItemCard(context, item, cart)),
                _billCard(cart),
                if (cart.subtotal < 250)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.saffronLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.saffron2.withOpacity(0.3))),
                    child: Text(
                      '🎉 Add ₹${(250 - cart.subtotal).toStringAsFixed(0)} more for FREE delivery!',
                      style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700,
                        color: AppColors.saffron)),
                  ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: SizedBox(width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                  child: Text('Proceed to Checkout  →  ₹${cart.grandTotal.toStringAsFixed(0)}',
                    style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800)),
                )),
            ),
          ]),
    );
  }

  Widget _emptyCart(BuildContext context) => Center(child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('🛒', style: TextStyle(fontSize: 72)),
      const SizedBox(height: 16),
      Text('Your cart is empty', style: GoogleFonts.playfairDisplay(
        fontSize: 22, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Text('Add some delicious meals!',
        style: GoogleFonts.nunito(fontSize: 14, color: AppColors.gray)),
    ],
  ));

  Widget _cartItemCard(BuildContext context, CartItem item, CartProvider cart) =>
    Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cream3, width: 1.5)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: AppColors.cream2, borderRadius: BorderRadius.circular(11)),
          child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 26)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.name, style: GoogleFonts.nunito(
            fontSize: 14, fontWeight: FontWeight.w800)),
          if (item.subtitle.isNotEmpty) Text(item.subtitle,
            style: GoogleFonts.nunito(fontSize: 12, color: AppColors.gray)),
          if (item.addons.isNotEmpty)
            Text('+ ${item.addons.join(", ")}',
              style: GoogleFonts.nunito(fontSize: 11, color: AppColors.green3),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(children: [
            Text('₹${item.total.toStringAsFixed(0)}',
              style: GoogleFonts.playfairDisplay(
                fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.green)),
            const Spacer(),
            _qtyControl(cart, item),
          ]),
        ])),
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.lgray),
          onPressed: () => cart.remove(item.uid)),
      ]),
    );

  Widget _qtyControl(CartProvider cart, CartItem item) => Row(children: [
    GestureDetector(
      onTap: () => cart.changeQty(item.uid, -1),
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: AppColors.xlgray, borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.remove, size: 16))),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text('${item.qty}',
        style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800))),
    GestureDetector(
      onTap: () => cart.changeQty(item.uid, 1),
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: AppColors.green, borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.add, size: 16, color: AppColors.white))),
  ]);

  Widget _billCard(CartProvider cart) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.white, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.cream3, width: 1.5)),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Subtotal', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.mid)),
        Text('₹${cart.subtotal.toStringAsFixed(0)}',
          style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Delivery', style: GoogleFonts.nunito(fontSize: 14, color: AppColors.mid)),
        Text(cart.deliveryCharge == 0 ? 'FREE' : '₹${cart.deliveryCharge.toStringAsFixed(0)}',
          style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700,
            color: cart.deliveryCharge == 0 ? AppColors.green : AppColors.dark)),
      ]),
      const Padding(padding: EdgeInsets.symmetric(vertical: 8),
        child: Divider(color: AppColors.cream3, thickness: 2)),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Total', style: GoogleFonts.playfairDisplay(
          fontSize: 18, fontWeight: FontWeight.w700)),
        Text('₹${cart.grandTotal.toStringAsFixed(0)}',
          style: GoogleFonts.playfairDisplay(
            fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.green)),
      ]),
    ]),
  );

  void _confirmClear(BuildContext context, CartProvider cart) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Clear Cart?'),
      content: const Text('Remove all items from your cart?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(onPressed: () { cart.clear(); Navigator.pop(context); },
          child: Text('Clear', style: TextStyle(color: AppColors.red))),
      ],
    ));
  }
}

// ─────────────────────────────────────────────────────────────
// CHECKOUT SCREEN
// ─────────────────────────────────────────────────────────────
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override State<CheckoutScreen> createState() => _CheckoutScreenState();
}
class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameCtrl    = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _noteCtrl    = TextEditingController();
  final _formKey     = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Details 🏠')),
      body: Form(
        key: _formKey,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          _field(_nameCtrl, 'Full Name', Icons.person_outline, hint: 'Your full name'),
          _field(_phoneCtrl, 'Phone Number', Icons.phone_outlined,
            hint: '+91 98765 43210', type: TextInputType.phone),
          _field(_addressCtrl, 'Delivery Address', Icons.home_outlined,
            hint: 'House No, Street, Area, City, PIN', maxLines: 2),
          _field(_noteCtrl, 'Delivery Instructions (Optional)',
            Icons.notes_outlined, hint: 'Leave at gate, call on arrival...'),
          const SizedBox(height: 8),
          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cream3, width: 1.5)),
            child: Column(children: [
              Text('Order Summary', style: GoogleFonts.nunito(
                fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              ...cart.items.map((i) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(child: Text('${i.name} × ${i.qty}',
                    style: GoogleFonts.nunito(fontSize: 13))),
                  Text('₹${i.total.toStringAsFixed(0)}',
                    style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700)),
                ]),
              )),
              const Divider(color: AppColors.cream3, thickness: 2, height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Total', style: GoogleFonts.playfairDisplay(
                  fontSize: 17, fontWeight: FontWeight.w700)),
                Text('₹${cart.grandTotal.toStringAsFixed(0)}',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.green)),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity,
            child: ElevatedButton(
              onPressed: _goToPayment,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              child: const Text('Continue to Payment →'),
            )),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon,
      {String? hint, TextInputType? type, int maxLines = 1}) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        keyboardType: type,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label, hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.green3)),
        validator: (v) => label.contains('Optional')
          ? null : (v == null || v.trim().isEmpty) ? 'Required' : null,
      ),
    );

  void _goToPayment() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen(
      customerName: _nameCtrl.text.trim(),
      customerPhone: _phoneCtrl.text.trim(),
      customerAddress: _addressCtrl.text.trim(),
      note: _noteCtrl.text.trim(),
    )));
  }
}

// ─────────────────────────────────────────────────────────────
// PAYMENT SCREEN
// ─────────────────────────────────────────────────────────────
class PaymentScreen extends StatefulWidget {
  final String customerName, customerPhone, customerAddress, note;
  const PaymentScreen({super.key,
    required this.customerName, required this.customerPhone,
    required this.customerAddress, required this.note});
  @override State<PaymentScreen> createState() => _PaymentScreenState();
}
class _PaymentScreenState extends State<PaymentScreen> {
  String _method = 'cod';
  bool _loading = false;
  final _upiCtrl = TextEditingController();
  final _cardNumCtrl  = TextEditingController();
  final _cardNameCtrl = TextEditingController();
  final _cardExpCtrl  = TextEditingController();
  final _cardCvvCtrl  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Payment 💳')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        // Amount Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.green, AppColors.green2],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Total Amount', style: GoogleFonts.nunito(
                fontSize: 13, color: Colors.white70)),
              Text('₹${cart.grandTotal.toStringAsFixed(0)}',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 34, fontWeight: FontWeight.w700, color: AppColors.white)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('Delivery', style: GoogleFonts.nunito(
                fontSize: 12, color: Colors.white60)),
              Text(cart.deliveryCharge == 0 ? 'FREE' : '₹${cart.deliveryCharge.toStringAsFixed(0)}',
                style: GoogleFonts.nunito(
                  fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.white)),
            ]),
          ]),
        ),

        const SizedBox(height: 20),
        Text('Choose Payment Method', style: GoogleFonts.nunito(
          fontSize: 11, fontWeight: FontWeight.w800,
          color: AppColors.gray, letterSpacing: 0.8)),
        const SizedBox(height: 10),

        // COD
        _methodCard('cod', '💵', 'Cash on Delivery', 'Pay when your order arrives'),
        // UPI
        _methodCard('upi', '📱', 'UPI Payment', 'PhonePe, GPay, Paytm & more'),
        // Card
        _methodCard('card', '💳', 'Debit / Credit Card', 'Visa, Mastercard, RuPay'),

        const SizedBox(height: 16),

        // Detail section
        if (_method == 'cod') _codDetail(),
        if (_method == 'upi') _upiDetail(),
        if (_method == 'card') _cardDetail(),

        const SizedBox(height: 20),
        SizedBox(width: double.infinity,
          child: ElevatedButton(
            onPressed: _loading ? null : _placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.saffron,
              padding: const EdgeInsets.all(16)),
            child: _loading
              ? const SizedBox(width: 20, height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text('🎉  Place Order & Pay',
                  style: GoogleFonts.nunito(
                    fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.white)),
          )),
        const SizedBox(height: 30),
      ]),
    );
  }

  Widget _methodCard(String id, String emoji, String title, String sub) {
    final sel = _method == id;
    return GestureDetector(
      onTap: () => setState(() => _method = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: sel ? AppColors.greenLight : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: sel ? AppColors.green : AppColors.cream3, width: 2)),
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22, height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: sel ? AppColors.green : AppColors.white,
              border: Border.all(
                color: sel ? AppColors.green : AppColors.lgray, width: 2)),
            child: sel ? const Icon(Icons.check, size: 14, color: AppColors.white) : null),
          const SizedBox(width: 12),
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800)),
            Text(sub, style: GoogleFonts.nunito(fontSize: 12, color: AppColors.gray)),
          ])),
        ]),
      ),
    );
  }

  Widget _codDetail() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.saffronLight,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.saffron2.withOpacity(0.3))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('🏠 Cash on Delivery', style: GoogleFonts.nunito(
        fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.saffron)),
      const SizedBox(height: 8),
      Text('Keep exact change ready. Our delivery agent will collect payment at your doorstep.',
        style: GoogleFonts.nunito(fontSize: 13, color: AppColors.mid)),
      const SizedBox(height: 12),
      ...['Place your order now',
          'Kitchen prepares your meal',
          'Agent delivers & collects cash 🎉'].asMap().entries.map((e) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(children: [
            Container(
              width: 22, height: 22,
              decoration: BoxDecoration(
                color: AppColors.saffron, shape: BoxShape.circle),
              child: Center(child: Text('${e.key+1}',
                style: GoogleFonts.nunito(
                  fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.white)))),
            const SizedBox(width: 10),
            Text(e.value, style: GoogleFonts.nunito(fontSize: 13, color: AppColors.mid)),
          ]),
        )),
    ]),
  );

  Widget _upiDetail() => Column(children: [
    // UPI app chips
    Row(children: ['📱 PhonePe','🇬 GPay','💙 Paytm','🏦 BHIM'].map((app) =>
      Expanded(child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cream, borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cream3)),
        child: Text(app, textAlign: TextAlign.center,
          style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w700)),
      ))).toList()),
    const SizedBox(height: 14),
    TextFormField(
      controller: _upiCtrl,
      decoration: const InputDecoration(
        labelText: 'UPI ID', hintText: 'yourname@okicici',
        prefixIcon: Icon(Icons.alternate_email, color: AppColors.green3)),
    ),
  ]);

  Widget _cardDetail() => Column(children: [
    // Card preview
    Container(
      height: 130,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.green, AppColors.green2],
          begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Ahmodia Restaurant', style: GoogleFonts.nunito(
            fontSize: 11, color: Colors.white60)),
          const Text('💳', style: TextStyle(fontSize: 24)),
        ]),
        const Spacer(),
        ValueListenableBuilder(
          valueListenable: _cardNumCtrl,
          builder: (_, v, __) => Text(
            v.text.isEmpty ? '•••• •••• •••• ••••' : v.text,
            style: GoogleFonts.nunito(fontSize: 16, color: AppColors.white,
              letterSpacing: 2, fontWeight: FontWeight.w600))),
        const SizedBox(height: 8),
        Row(children: [
          ValueListenableBuilder(
            valueListenable: _cardNameCtrl,
            builder: (_, v, __) => Text(
              v.text.isEmpty ? 'CARD HOLDER' : v.text.toUpperCase(),
              style: GoogleFonts.nunito(fontSize: 12, color: Colors.white70))),
          const Spacer(),
          ValueListenableBuilder(
            valueListenable: _cardExpCtrl,
            builder: (_, v, __) => Text(
              v.text.isEmpty ? 'MM/YY' : v.text,
              style: GoogleFonts.nunito(fontSize: 12, color: Colors.white70))),
        ]),
      ]),
    ),
    const SizedBox(height: 14),
    TextFormField(controller: _cardNumCtrl,
      keyboardType: TextInputType.number,
      maxLength: 19,
      decoration: const InputDecoration(
        labelText: 'Card Number', hintText: '1234 5678 9012 3456',
        counterText: '',
        prefixIcon: Icon(Icons.credit_card, color: AppColors.green3))),
    const SizedBox(height: 12),
    TextFormField(controller: _cardNameCtrl,
      textCapitalization: TextCapitalization.characters,
      decoration: const InputDecoration(
        labelText: 'Cardholder Name', hintText: 'NAME AS ON CARD',
        prefixIcon: Icon(Icons.person_outline, color: AppColors.green3))),
    const SizedBox(height: 12),
    Row(children: [
      Expanded(child: TextFormField(controller: _cardExpCtrl,
        keyboardType: TextInputType.number,
        maxLength: 5,
        decoration: const InputDecoration(
          labelText: 'Expiry', hintText: 'MM/YY', counterText: '',
          prefixIcon: Icon(Icons.calendar_today_outlined, color: AppColors.green3)))),
      const SizedBox(width: 12),
      Expanded(child: TextFormField(controller: _cardCvvCtrl,
        keyboardType: TextInputType.number,
        maxLength: 3, obscureText: true,
        decoration: const InputDecoration(
          labelText: 'CVV', hintText: '•••', counterText: '',
          prefixIcon: Icon(Icons.lock_outline, color: AppColors.green3)))),
    ]),
    const SizedBox(height: 8),
    Row(children: [
      const Icon(Icons.lock, size: 14, color: AppColors.green3),
      const SizedBox(width: 6),
      Text('256-bit SSL encrypted. Your card details are safe.',
        style: GoogleFonts.nunito(fontSize: 12, color: AppColors.gray)),
    ]),
  ]);

  Future<void> _placeOrder() async {
    if (_method == 'upi' && !_upiCtrl.text.contains('@')) {
      _showSnack('Please enter a valid UPI ID');
      return;
    }
    setState(() => _loading = true);
    final cart = context.read<CartProvider>();
    final orderId = FirebaseService.generateOrderId();

    // TODO: integrate Razorpay for UPI/Card here
    // For COD, save directly to Firestore
    final order = OrderModel(
      orderId: orderId,
      userId: FirebaseService.currentUser?.uid ?? 'guest',
      customerName: widget.customerName,
      customerPhone: widget.customerPhone,
      customerAddress: widget.customerAddress,
      items: cart.toOrderItems(),
      total: cart.grandTotal,
      paymentMethod: _method.toUpperCase(),
      createdAt: DateTime.now(),
    );

    await FirebaseService.placeOrder(order);
    cart.clear();
    setState(() => _loading = false);

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (_) => OrderSuccessScreen(
        orderId: orderId, total: order.total)),
      (route) => route.isFirst);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg), backgroundColor: AppColors.red,
      behavior: SnackBarBehavior.floating));
  }
}

// ─────────────────────────────────────────────────────────────
// ORDER SUCCESS
// ─────────────────────────────────────────────────────────────
class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final double total;
  const OrderSuccessScreen({super.key, required this.orderId, required this.total});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('🎉', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 20),
        Text('Order Placed!', style: GoogleFonts.playfairDisplay(
          fontSize: 28, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Your meal is being prepared with love!',
          style: GoogleFonts.nunito(fontSize: 14, color: AppColors.gray),
          textAlign: TextAlign.center),
        const SizedBox(height: 28),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.greenLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.green3.withOpacity(0.4))),
          child: Column(children: [
            Text('Your Order ID', style: GoogleFonts.nunito(
              fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.gray)),
            const SizedBox(height: 6),
            Text(orderId, style: GoogleFonts.playfairDisplay(
              fontSize: 34, fontWeight: FontWeight.w700, color: AppColors.green)),
            const SizedBox(height: 4),
            Text('Save this to track your order',
              style: GoogleFonts.nunito(fontSize: 12, color: AppColors.gray)),
          ]),
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cream, borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              Text('35 min', style: GoogleFonts.nunito(
                fontSize: 18, fontWeight: FontWeight.w800)),
              Text('Est. Delivery', style: GoogleFonts.nunito(
                fontSize: 12, color: AppColors.gray)),
            ]))),
          const SizedBox(width: 12),
          Expanded(child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cream, borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              Text('₹${total.toStringAsFixed(0)}', style: GoogleFonts.playfairDisplay(
                fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.green)),
              Text('Total', style: GoogleFonts.nunito(fontSize: 12, color: AppColors.gray)),
            ]))),
        ]),
        const SizedBox(height: 28),
        SizedBox(width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const MainShell())),
            child: const Text('📍  Track My Order'))),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const MainShell())),
          child: Text('Continue Ordering',
            style: GoogleFonts.nunito(color: AppColors.gray, fontWeight: FontWeight.w700))),
      ]),
    )),
  );
}

// ─────────────────────────────────────────────────────────────
// TRACK SCREEN
// ─────────────────────────────────────────────────────────────
class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});
  @override State<TrackScreen> createState() => _TrackScreenState();
}
class _TrackScreenState extends State<TrackScreen> {
  final _ctrl = TextEditingController();
  OrderModel? _trackedOrder;
  bool _searching = false;
  bool _notFound = false;
  List<OrderModel> _myOrders = [];

  @override
  void initState() {
    super.initState();
    _loadMyOrders();
  }

  Future<void> _loadMyOrders() async {
    final uid = FirebaseService.currentUser?.uid;
    if (uid != null) {
      final orders = await FirebaseService.getUserOrders(uid);
      setState(() => _myOrders = orders);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Track Order 📍')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      // Search
      Row(children: [
        Expanded(child: TextFormField(
          controller: _ctrl,
          decoration: const InputDecoration(
            hintText: 'Enter Order ID  e.g. AH-1001',
            prefixIcon: Icon(Icons.search, color: AppColors.green3)),
          onFieldSubmitted: (_) => _track(),
        )),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _searching ? null : _track,
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(14)),
          child: const Text('Track')),
      ]),
      const SizedBox(height: 20),

      if (_searching) const Center(child: CircularProgressIndicator(color: AppColors.green)),
      if (_notFound) _notFoundWidget(),
      if (_trackedOrder != null) _trackResult(_trackedOrder!),

      if (_myOrders.isNotEmpty) ...[
        const SectionTitle(title: '📦 Recent Orders'),
        ..._myOrders.map((o) => OrderMiniCard(
          order: o,
          onTap: () { _ctrl.text = o.orderId; _track(); })),
      ],
    ]),
  );

  Future<void> _track() async {
    final id = _ctrl.text.trim().toUpperCase();
    if (id.isEmpty) return;
    setState(() { _searching = true; _notFound = false; _trackedOrder = null; });
    // Listen live
    FirebaseService.streamOrder(id).first.then((order) {
      setState(() {
        _searching = false;
        _trackedOrder = order;
        _notFound = order == null;
      });
    });
  }

  Widget _notFoundWidget() => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(14)),
    child: Column(children: [
      const Text('😕', style: TextStyle(fontSize: 40)),
      const SizedBox(height: 8),
      Text('Order Not Found', style: GoogleFonts.nunito(
        fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.red)),
      Text('Check your order ID and try again',
        style: GoogleFonts.nunito(fontSize: 13, color: const Color(0xFFB91C1C))),
    ]),
  );

  Widget _trackResult(OrderModel order) {
    final statuses = AppData.statusList;
    final sIdx = statuses.indexOf(order.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cream3, width: 1.5)),
      child: Column(children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.green, AppColors.green2]),
            borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
          child: Row(children: [
            Text(order.orderId, style: GoogleFonts.playfairDisplay(
              fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.white)),
            const Spacer(),
            StatusBadge(status: order.status),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            // Info grid
            GridView.count(
              crossAxisCount: 2, shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10, mainAxisSpacing: 10,
              childAspectRatio: 2.5,
              children: [
                _infoBox('Customer', order.customerName),
                _infoBox('Total', '₹${order.total.toStringAsFixed(0)}'),
                _infoBox('Payment', order.paymentMethod),
                _infoBox('Status', order.status),
              ]),
            const SizedBox(height: 16),
            // Timeline
            ...statuses.asMap().entries.map((e) {
              final i = e.key; final s = e.value;
              final done = i < sIdx; final current = i == sIdx;
              return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Column(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? AppColors.green
                           : current ? AppColors.white : AppColors.xlgray,
                      border: Border.all(
                        color: done ? AppColors.green
                             : current ? AppColors.saffron : AppColors.cream3,
                        width: 2.5)),
                    child: Center(child: Text(
                      done ? '✓' : AppData.statusIcons[s] ?? '○',
                      style: TextStyle(fontSize: done ? 14 : 12,
                        color: done ? AppColors.white
                             : current ? AppColors.saffron : AppColors.lgray)))),
                  if (i < statuses.length - 1) Container(
                    width: 2, height: 28,
                    color: done ? AppColors.green : AppColors.cream3),
                ]),
                const SizedBox(width: 14),
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(s, style: GoogleFonts.nunito(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      color: i <= sIdx ? AppColors.dark : AppColors.lgray)),
                    Text([
                      'Order received, awaiting kitchen',
                      'Kitchen confirmed your order',
                      'Our chef is preparing your meal',
                      'On the way to your location 🏍️',
                      'Delivered! Enjoy your meal 🎉',
                    ][i], style: GoogleFonts.nunito(fontSize: 12, color: AppColors.gray)),
                  ]),
                )),
              ]);
            }),
            // Agent strip
            if (order.agentName != null && order.agentName!.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.greenLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.green3.withOpacity(0.3))),
                child: Row(children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.green, shape: BoxShape.circle),
                    child: const Center(child: Text('🧑', style: TextStyle(fontSize: 22)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(order.agentName!, style: GoogleFonts.nunito(
                      fontSize: 14, fontWeight: FontWeight.w800)),
                    Text('Delivery Agent · En route',
                      style: GoogleFonts.nunito(fontSize: 12, color: AppColors.gray)),
                  ])),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.call, size: 14),
                    label: const Text('Call'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8))),
                ]),
              ),
          ]),
        ),
      ]),
    );
  }

  Widget _infoBox(String label, String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.cream, borderRadius: BorderRadius.circular(10)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.nunito(
        fontSize: 10, fontWeight: FontWeight.w700,
        color: AppColors.gray, letterSpacing: 0.5)),
      Text(value, style: GoogleFonts.nunito(
        fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.dark)),
    ]),
  );
}

// ─────────────────────────────────────────────────────────────
// PROFILE SCREEN
// ─────────────────────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _profile;
  bool _editing = false;
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseService.currentUser?.uid;
    if (uid != null) {
      final p = await FirebaseService.getProfile(uid);
      setState(() {
        _profile = p;
        if (p != null) {
          _nameCtrl.text = p.name;
          _phoneCtrl.text = p.phone;
          _addressCtrl.text = p.address;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null && FirebaseService.currentUser == null) {
      return _loginPrompt(context);
    }
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 180,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.green, AppColors.green2],
                  begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(height: 40),
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withOpacity(0.15),
                    border: Border.all(color: AppColors.white.withOpacity(0.4), width: 3)),
                  child: const Center(child: Text('👤', style: TextStyle(fontSize: 34)))),
                const SizedBox(height: 8),
                Text(_profile?.name ?? 'Guest',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.white)),
                Text(_profile?.email ?? '',
                  style: GoogleFonts.nunito(
                    fontSize: 12, color: AppColors.white.withOpacity(0.65))),
              ]),
            ),
          ),
        ),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            // Stats
            Row(children: [
              _statBox('${_profile?.orderCount ?? 0}', 'Orders'),
              const SizedBox(width: 10),
              _statBox('₹${(_profile?.totalSpent ?? 0).toStringAsFixed(0)}', 'Spent'),
              const SizedBox(width: 10),
              _statBox('4.8★', 'Rating'),
            ]),
            const SizedBox(height: 20),

            // Info or Edit Form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white, borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cream3, width: 1.5)),
              child: Column(children: [
                if (!_editing) ...[
                  InfoRow(icon: Icons.person_outline,
                    label: 'Full Name', value: _profile?.name ?? '',
                    onEdit: () => setState(() => _editing = true)),
                  const Divider(color: AppColors.xlgray),
                  InfoRow(icon: Icons.email_outlined,
                    label: 'Email', value: _profile?.email ?? ''),
                  const Divider(color: AppColors.xlgray),
                  InfoRow(icon: Icons.phone_outlined,
                    label: 'Phone', value: _profile?.phone ?? '',
                    onEdit: () => setState(() => _editing = true)),
                  const Divider(color: AppColors.xlgray),
                  InfoRow(icon: Icons.home_outlined,
                    label: 'Delivery Address', value: _profile?.address ?? '',
                    onEdit: () => setState(() => _editing = true)),
                ] else ...[
                  TextFormField(controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Full Name')),
                  const SizedBox(height: 12),
                  TextFormField(controller: _phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone),
                  const SizedBox(height: 12),
                  TextFormField(controller: _addressCtrl,
                    decoration: const InputDecoration(labelText: 'Delivery Address'),
                    maxLines: 2),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text('Save Changes'))),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () => setState(() => _editing = false),
                      child: const Text('Cancel')),
                  ]),
                ],
              ]),
            ),
            const SizedBox(height: 20),

            // Menu
            _menuListItem(Icons.shopping_bag_outlined, 'My Orders', 'View order history', () {}),
            _menuListItem(Icons.local_offer_outlined, 'Coupons & Offers', 'See discounts', () {}),
            _menuListItem(Icons.logout_rounded, 'Sign Out', 'Clear session',
              _signOut, color: AppColors.red),
          ]),
        )),
      ]),
    );
  }

  Widget _statBox(String val, String label) => Expanded(child: Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.cream, borderRadius: BorderRadius.circular(12)),
    child: Column(children: [
      Text(val, style: GoogleFonts.playfairDisplay(
        fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.green)),
      Text(label, style: GoogleFonts.nunito(
        fontSize: 12, color: AppColors.gray, fontWeight: FontWeight.w600)),
    ]),
  ));

  Widget _menuListItem(IconData icon, String title, String sub, VoidCallback onTap,
      {Color? color}) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cream3, width: 1.5)),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: (color ?? AppColors.green).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color ?? AppColors.green)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.nunito(
            fontSize: 14, fontWeight: FontWeight.w700, color: color ?? AppColors.dark)),
          Text(sub, style: GoogleFonts.nunito(fontSize: 12, color: AppColors.gray)),
        ])),
        Icon(Icons.chevron_right_rounded, color: AppColors.lgray),
      ]),
    ),
  );

  Future<void> _saveProfile() async {
    if (_profile == null) return;
    _profile!.phone = _phoneCtrl.text.trim();
    _profile!.address = _addressCtrl.text.trim();
    await FirebaseService.updateProfile(_profile!);
    setState(() => _editing = false);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved!'),
        backgroundColor: AppColors.green, behavior: SnackBarBehavior.floating));
  }

  Future<void> _signOut() async {
    await FirebaseService.signOut();
    setState(() => _profile = null);
  }

  Widget _loginPrompt(BuildContext context) => Scaffold(
    body: Center(child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('👤', style: TextStyle(fontSize: 72)),
        const SizedBox(height: 20),
        Text('Sign in to continue', style: GoogleFonts.playfairDisplay(
          fontSize: 24, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Access your orders, profile & saved address',
          style: GoogleFonts.nunito(fontSize: 14, color: AppColors.gray),
          textAlign: TextAlign.center),
        const SizedBox(height: 32),
        SizedBox(width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Text('G', style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
            label: const Text('Continue with Google'),
            onPressed: () async {
              final profile = await FirebaseService.signInWithGoogle();
              if (profile != null) setState(() => _profile = profile);
            },
          )),
      ]),
    )),
  );
}

// Import needed in this file
import '../services/firebase_service.dart';
