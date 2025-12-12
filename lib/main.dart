import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart'; // Bỏ comment khi dùng Firebase sau
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Nếu sau này dùng Firebase thì bỏ comment
  // await Firebase.initializeApp();

  runApp(const ClassPalApp());
}