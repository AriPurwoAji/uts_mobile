import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/services/dio_clients.dart';
import 'core/services/secure_storage.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/category/presentation/category_provider.dart';
import 'features/category/data/category_repository.dart';
import 'features/product/presentation/product_provider.dart';
import 'features/product/data/product_repository.dart';
import 'features/cart/presentation/cart_provider.dart';
import 'features/cart/data/cart_repository.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final secureStorage = SecureStorage();
    final dioClient = DioClient();

    return MultiProvider(
      providers: [
        // Auth — dari materi (tidak diubah)
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Category — BARU
        ChangeNotifierProvider(create: (_) =>
          CategoryProvider(CategoryRepository(dioClient))),

        // Product — BARU
        ChangeNotifierProvider(create: (_) =>
          ProductProvider(ProductRepository(dioClient))),

        // Cart — BARU
        ChangeNotifierProvider(create: (_) =>
          CartProvider(CartRepository(dioClient))),
      ],
      child: MaterialApp(
        title: 'Hydrau-Link',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,   // ← pakai theme baru
        home: const LoginPage(), // ← tetap dari materi
      ),
    );
  }
}