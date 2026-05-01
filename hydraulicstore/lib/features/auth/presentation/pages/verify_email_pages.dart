import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_providers.dart';
import '../../../home/presentation/pages/home_page.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi Email")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_read_outlined,
              size: 80, color: Color(0xFFFF6B35)),
            const SizedBox(height: 20),

            const Text(
              "Kami telah mengirim email verifikasi.\nSilakan cek inbox kamu.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            const Text(
              "Setelah klik link di email, tekan tombol di bawah.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),

            const SizedBox(height: 24),

            // BUTTON CEK VERIFIKASI
            authProvider.isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final success = await context
                            .read<AuthProvider>()
                            .checkEmailVerification();

                        if (success && context.mounted) {
                          // ← navigasi ke HomePage setelah verifikasi berhasil
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomePage()),
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Saya sudah verifikasi"),
                    ),
                  ),

            const SizedBox(height: 12),

            // RESEND EMAIL
            TextButton(
              onPressed: () async {
                await context
                    .read<AuthProvider>()
                    .resendVerificationEmail();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Email verifikasi dikirim ulang"),
                      backgroundColor: Color(0xFF1A2B4A),
                    ),
                  );
                }
              },
              child: const Text("Kirim ulang email",
                style: TextStyle(color: Color(0xFF1A2B4A))),
            ),

            // ERROR MESSAGE
            if (authProvider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  authProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}