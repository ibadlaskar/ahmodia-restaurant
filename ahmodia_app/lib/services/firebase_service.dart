// lib/services/firebase_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/models.dart';

class FirebaseService {
  static final _auth      = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  static final _googleSignIn = GoogleSignIn();

  // ── AUTH ──────────────────────────────────────────────────
  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStream => _auth.authStateChanges();

  static Future<UserProfile?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      final user = result.user!;

      // Check if profile exists
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        // Create new profile
        final profile = UserProfile(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          photo: user.photoURL ?? '',
        );
        await _firestore.collection('users').doc(user.uid)
            .set(profile.toFirestore());
        return profile;
      } else {
        return UserProfile.fromFirestore(user.uid, doc.data()!);
      }
    } catch (e) {
      return null;
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // ── USER PROFILE ───────────────────────────────────────────
  static Future<UserProfile?> getProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromFirestore(uid, doc.data()!);
  }

  static Future<void> updateProfile(UserProfile profile) async {
    await _firestore.collection('users')
        .doc(profile.uid)
        .update(profile.toFirestore());
  }

  // ── ORDERS ─────────────────────────────────────────────────
  static Future<String> placeOrder(OrderModel order) async {
    final docRef = _firestore.collection('orders').doc();
    
    await docRef.set(order.toFirestore());

    // Update user stats
    final uid = order.userId;
    if (uid.isNotEmpty) {
      await _firestore.collection('users').doc(uid).update({
        'orderCount': FieldValue.increment(1),
        'totalSpent': FieldValue.increment(order.total),
        'lastOrderAt': FieldValue.serverTimestamp(),
      });
    }
    return order.orderId;
  }

  // Stream: live order by ID
  static Stream<OrderModel?> streamOrder(String orderId) {
    return _firestore.collection('orders')
        .where('orderId', isEqualTo: orderId)
        .limit(1)
        .snapshots()
        .map((snap) {
      if (snap.docs.isEmpty) return null;
      return OrderModel.fromFirestore(snap.docs.first.data());
    });
  }

  // Get all orders for a user
  static Future<List<OrderModel>> getUserOrders(String userId) async {
    final snap = await _firestore.collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();
    return snap.docs.map((d) => OrderModel.fromFirestore(d.data())).toList();
  }

  // ── MENU (from Firestore, admin-editable) ──────────────────
  static Future<List<Map<String, dynamic>>> getMenu() async {
    final snap = await _firestore.collection('menu').get();
    return snap.docs.map((d) => d.data()).toList();
  }

  // Helper: generate unique order ID
  static String generateOrderId() {
    final now = DateTime.now();
    return 'AH-${now.millisecondsSinceEpoch.toString().substring(7)}';
  }
}
