import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../cart_provider.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final Map<int, int> _localQty = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().fetchCart();
    });
  }

  String _formatRp(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        actions: [
          Consumer<CartProvider>(
            builder: (ctx, provider, child) {
              final hasItems = (provider.cart?.items.isNotEmpty) ?? false;
              if (!hasItems) return const SizedBox();
              return IconButton(
                icon: const Icon(Icons.delete_outline, color: AppTheme.darkNavy),
                tooltip: 'Kosongkan keranjang',
                onPressed: () async {
                  final items = provider.cart?.items ?? [];
                  for (final item in items) {
                    await provider.removeFromCart(item.id);
                  }
                  setState(() => _localQty.clear());
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (ctx, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final cart = provider.cart;
          if (cart == null || cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('Keranjang masih kosong',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mulai Belanja'),
                  ),
                ],
              ),
            );
          }

          for (final item in cart.items) {
            _localQty.putIfAbsent(item.id, () => item.quantity);
          }

          double total = 0;
          for (final item in cart.items) {
            total += item.price * (_localQty[item.id] ?? item.quantity);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  itemCount: cart.items.length,
                  itemBuilder: (ctx2, i) {
                    final item = cart.items[i];
                    final qty = _localQty[item.id] ?? item.quantity;
                    final subtotal = item.price * qty;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade100,
                              blurRadius: 8,
                              offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Gambar produk
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 76,
                              height: 76,
                              color: AppTheme.lightGrey,
                              child: item.productImage.isNotEmpty
                                  ? Image.network(item.productImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => const Icon(
                                          Icons.precision_manufacturing_outlined,
                                          color: AppTheme.darkNavy))
                                  : const Icon(
                                      Icons.precision_manufacturing_outlined,
                                      color: AppTheme.darkNavy),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(item.productName,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.5,
                                            color: AppTheme.darkNavy,
                                          )),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        provider.removeFromCart(item.id);
                                        setState(() => _localQty.remove(item.id));
                                      },
                                      child: const Icon(Icons.delete_outline,
                                          color: Colors.red, size: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(_formatRp(item.price),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    // Qty control
                                    Container(
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (qty > 1) {
                                                setState(() =>
                                                    _localQty[item.id] = qty - 1);
                                              } else {
                                                provider
                                                    .removeFromCart(item.id);
                                                setState(() =>
                                                    _localQty.remove(item.id));
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 4),
                                              child: const Icon(Icons.remove,
                                                  size: 16),
                                            ),
                                          ),
                                          Text('$qty',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                          GestureDetector(
                                            onTap: () => setState(
                                                () => _localQty[item.id] =
                                                    qty + 1),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 4),
                                              child: const Icon(Icons.add,
                                                  size: 16,
                                                  color: AppTheme.primaryOrange),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(_formatRp(subtotal),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppTheme.primaryOrange,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom bar — total + checkout
              Container(
                padding: EdgeInsets.fromLTRB(
                    16, 12, 16, MediaQuery.of(context).padding.bottom + 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 8,
                        offset: const Offset(0, -2)),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Total',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(_formatRp(total),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkNavy,
                            )),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final items = cart.items
                              .map((item) => {
                                    'name': item.productName,
                                    'price': item.price,
                                    'qty': _localQty[item.id] ?? item.quantity,
                                  })
                              .toList();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutPage(
                                cartItems: items,
                                total: total,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Checkout',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
