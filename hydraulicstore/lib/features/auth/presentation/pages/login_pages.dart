import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_providers.dart';
import '../../../home/presentation/pages/home_page.dart';
import 'register_pages.dart';
import 'verify_email_pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey          = GlobalKey<FormState>();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.loginWithEmail(
      email:    _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const HomePage()));
    } else if (auth.status == AuthStatus.emailNotVerified) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const VerifyEmailPage()));
    }
  }

  Future<void> _loginWithGoogle() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.loginWithGoogle();
    if (success && mounted) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header Banner ──────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 48, horizontal: 24),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A2B4A),
                  borderRadius: BorderRadius.only(
                    bottomLeft:  Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    // Logo
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.water_drop,
                        color: Color(0xFFFF6B35), size: 48),
                    ),
                    const SizedBox(height: 16),
                    const Text('HYDRAU-LINK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('Your Digital Hydraulic Partner',
                      style: TextStyle(
                        color: Colors.white60, fontSize: 13)),
                  ],
                ),
              ),

              // ── Form Area ──────────────────────────────
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text('Masuk ke Akun',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A2B4A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('Selamat datang kembali!',
                        style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 24),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined,
                            color: Color(0xFFFF6B35)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF6B35), width: 2)),
                        ),
                        validator: (v) =>
                          (v == null || v.isEmpty) ? 'Email wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline,
                            color: Color(0xFFFF6B35)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF6B35), width: 2)),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                              color: Colors.grey),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) =>
                          (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
                      ),
                      const SizedBox(height: 20),

                      // Error message
                      Consumer<AuthProvider>(
                        builder: (_, auth, _) {
                          if (auth.status == AuthStatus.error) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline,
                                    color: Colors.red, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      auth.errorMessage ?? 'Terjadi kesalahan',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),

                      // Tombol Login
                      Consumer<AuthProvider>(
                        builder: (_, auth, _) {
                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: auth.isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B35),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              ),
                              child: auth.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text('Masuk',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Divider
                      Row(children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('atau',
                            style: TextStyle(color: Colors.grey.shade500)),
                        ),
                        const Expanded(child: Divider()),
                      ]),
                      const SizedBox(height: 16),

                      // Tombol Google
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: _loginWithGoogle,
                          icon: const Icon(Icons.g_mobiledata,
                            size: 28, color: Color(0xFF1A2B4A)),
                          label: const Text('Masuk dengan Google',
                            style: TextStyle(
                              color: Color(0xFF1A2B4A),
                              fontWeight: FontWeight.w600)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1A2B4A)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Link ke Register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Belum punya akun? '),
                          GestureDetector(
                            onTap: () => Navigator.push(context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage())),
                            child: const Text('Daftar Sekarang',
                              style: TextStyle(
                                color: Color(0xFFFF6B35),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}