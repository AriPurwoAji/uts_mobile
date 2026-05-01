import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dio/dio.dart'; // Tambahkan import ini
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/services/dio_clients.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/category/presentation/category_provider.dart';
import 'features/category/data/category_repository.dart';
import 'features/product/presentation/product_provider.dart';
import 'features/product/data/product_repository.dart';
import 'features/cart/presentation/cart_provider.dart';
import 'features/cart/data/cart_repository.dart';
import 'features/auth/presentation/pages/login_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil instance Dio dari singleton yang kamu buat
    final dio = DioClient.instance; 

    return MultiProvider(
      providers: [
        // Daftarkan dio sebagai provider agar bisa dibaca oleh repository
        Provider<Dio>.value(value: dio),

        // Auth — tetap sama
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Category — Gunakan instance dio
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(
            CategoryRepository(dio),
          ),
        ),

        // Product — Gunakan instance dio
        ChangeNotifierProvider(
          create: (context) => ProductProvider(
            ProductRepository(dio),
          ),
        ),

        // Cart — Gunakan instance dio
        ChangeNotifierProvider(
          create: (context) => CartProvider(
            CartRepository(dio),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Hydrau-Link',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const LoginPage(),
      ),
    );
  }
}