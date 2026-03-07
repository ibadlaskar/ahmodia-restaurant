// lib/services/firebase_service.dart
// Stub version - Firebase will be added after first successful build
import '../models/models.dart';

class _FakeUser {
  final String uid;
  final String displayName;
  final String email;
  _FakeUser({required this.uid, required this.displayName, required this.email});
}

class FirebaseService {
  static _FakeUser? _user;

  static dynamic get currentUser => _user;

  static Future<UserProfile?> signInWithGoogle() async {
    _user = _FakeUser(
      uid: 'guest_001',
      displayName: 'Guest User',
      email: 'guest@ahmodia.com',
    );
    return UserProfile(
      uid: _user!.uid,
      name: _user!.displayName,
      email: _user!.email,
      photo: '',
    );
  }

  static Future<void> signOut() async {
    _user = null;
  }

  static Future<UserProfile?> getProfile(String uid) async {
    return null;
  }

  static Future<void> updateProfile(UserProfile profile) async {}

  static Future<String> placeOrder(OrderModel order) async {
    return order.orderId;
  }

  static Stream<OrderModel?> streamOrder(String orderId) {
    return Stream.value(null);
  }

  static Future<List<OrderModel>> getUserOrders(String userId) async {
    return [];
  }

  static String generateOrderId() {
    final now = DateTime.now();
    return 'AH-${now.millisecondsSinceEpoch.toString().substring(7)}';
  }
}
