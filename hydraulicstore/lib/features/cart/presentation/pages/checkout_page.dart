import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double total;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.total,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  String _paymentMethod = 'dkg';

  @override
  void dispose() {
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatRp(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}';
  }

  Future<void> _pay() async {
    if (_paymentMethod == 'dkg') {
      final orderId = 'HS-${DateTime.now().millisecondsSinceEpoch}';
      final uri = Uri.parse(
        'dkg://checkout?store=Hydraulic+Store&order=$orderId&amount=${widget.total.toStringAsFixed(0)}',
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('App Dompet Kampus Global tidak ditemukan'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pesanan berhasil dibuat!'),
            backgroundColor: AppTheme.primaryOrange,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, MediaQuery.of(context).padding.bottom + 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ringkasan Pesanan
            const Text('Ringkasan Pesanan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkNavy,
                )),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade100,
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                children: [
                  ...widget.cartItems.map((item) {
                    final subtotal =
                        (item['price'] as double) * (item['qty'] as int);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.5,
                                      color: AppTheme.darkNavy,
                                    )),
                                const SizedBox(height: 2),
                                Text(
                                    '${item['qty']} x ${_formatRp(item['price'] as double)}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                          Text(_formatRp(subtotal),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                                color: AppTheme.darkNavy,
                              )),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkNavy,
                          )),
                      Text(_formatRp(widget.total),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryOrange,
                          )),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Alamat Pengiriman
            const Text('Alamat Pengiriman',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkNavy,
                )),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Masukkan alamat lengkap',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: AppTheme.primaryOrange, width: 2)),
              ),
            ),

            const SizedBox(height: 20),

            // Catatan
            const Text('Catatan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkNavy,
                )),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Catatan opsional',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: AppTheme.primaryOrange, width: 2)),
              ),
            ),

            const SizedBox(height: 20),

            // Metode Pembayaran
            const Text('Metode Pembayaran',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkNavy,
                )),
            const SizedBox(height: 10),
            _paymentOption(
              value: 'dkg',
              title: 'Dompet Kampus Global',
              subtitle: 'Bayar via Dompet Kampus Global',
              icon: Icons.account_balance_wallet_outlined,
            ),
            const SizedBox(height: 8),
            _paymentOption(
              value: 'bank',
              title: 'Transfer Bank',
              subtitle: 'BCA, Mandiri, BNI, BRI',
              icon: Icons.account_balance_outlined,
            ),
            const SizedBox(height: 8),
            _paymentOption(
              value: 'va',
              title: 'Virtual Account',
              subtitle: 'Nomor VA otomatis digenerate',
              icon: Icons.credit_card_outlined,
            ),

            const SizedBox(height: 28),

            // Tombol bayar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _pay,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  _paymentMethod == 'dkg'
                      ? 'Bayar dengan Dompet Kampus Global'
                      : 'Konfirmasi Pesanan',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = _paymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryOrange.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppTheme.primaryOrange : Colors.grey.shade200,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color:
                    selected ? AppTheme.primaryOrange : AppTheme.darkNavy),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selected
                            ? AppTheme.primaryOrange
                            : AppTheme.darkNavy,
                      )),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle,
                  color: AppTheme.primaryOrange, size: 20),
          ],
        ),
      ),
    );
  }
}
