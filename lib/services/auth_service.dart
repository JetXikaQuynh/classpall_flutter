import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  ValueNotifier
  static final ValueNotifier<bool?> isAdminNotifier = ValueNotifier<bool?>(
    null,
  );

  // Getter tiện lợi
  static bool get isAdmin => isAdminNotifier.value ?? false;
  static bool? get isAdminOrNull => isAdminNotifier.value;

  // User hiện tại
  static User? get currentUser => _auth.currentUser;

  // Stream auth state
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // === Hàm đăng nhập ===
  static Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _loadUserRole(); // Tải role ngay sau khi login thành công
      return true;
    } on FirebaseAuthException catch (e) {
      print('Login error: ${e.message}');
      return false;
    }
  }

  // ===  Tải role từ Firestore ===
  static Future<void> _loadUserRole() async {
    final user = currentUser;
    if (user == null) {
      isAdminNotifier.value = null;
      return;
    }

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        final bool admin = data?['role'] as bool? ?? false;
        isAdminNotifier.value = admin;
      } else {
        isAdminNotifier.value = false;
      }
    } catch (e) {
      print('Error loading role: $e');
      isAdminNotifier.value = false;
    }
  }

  static Future<void> initialize() async {
    if (currentUser != null) {
      await _loadUserRole();
    }
  }

  // Trong AuthService
static Future<int> getTotalMembers() async {
  final snap = await FirebaseFirestore.instance.collection('users').get();
  return snap.size;
}

  static Future<void> signOut() async {
    await _auth.signOut();
    isAdminNotifier.value = null;
  }
}
