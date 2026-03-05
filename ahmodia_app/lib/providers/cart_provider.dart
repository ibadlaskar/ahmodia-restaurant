// lib/providers/cart_provider.dart
import 'package:flutter/material.dart';
import '../models/models.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.qty);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);

  double get deliveryCharge => subtotal >= 250 ? 0 : 30;

  double get grandTotal => subtotal + deliveryCharge;

  void addPackItem({
    required String name,
    required String emoji,
    required String size,
    required List<Addon> selectedAddons,
    required double ricePrice,
  }) {
    final addonsTotal = selectedAddons.fold(0.0, (s, a) => s + a.price);
    _items.add(CartItem(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '$size Rice Pack',
      emoji: emoji,
      subtitle: size == 'Half' ? '~300g Rice' : '~500g Rice',
      size: size,
      addons: selectedAddons.map((a) => a.name).toList(),
      unitPrice: ricePrice + addonsTotal,
    ));
    notifyListeners();
  }

  void addDirectItem(MenuItem item) {
    final existing = _items.where(
      (c) => c.name == item.name && c.size.isEmpty).toList();
    if (existing.isNotEmpty) {
      existing.first.qty++;
    } else {
      _items.add(CartItem(
        uid: DateTime.now().millisecondsSinceEpoch.toString(),
        name: item.name,
        emoji: item.emoji,
        subtitle: item.category,
        unitPrice: item.price,
      ));
    }
    notifyListeners();
  }

  void changeQty(String uid, int delta) {
    final idx = _items.indexWhere((c) => c.uid == uid);
    if (idx < 0) return;
    _items[idx].qty += delta;
    if (_items[idx].qty <= 0) _items.removeAt(idx);
    notifyListeners();
  }

  void remove(String uid) {
    _items.removeWhere((c) => c.uid == uid);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  List<Map<String, dynamic>> toOrderItems() => _items.map((c) => {
    'name': c.name,
    'emoji': c.emoji,
    'qty': c.qty,
    'price': c.unitPrice,
    'size': c.size,
    'addons': c.addons,
  }).toList();
}
