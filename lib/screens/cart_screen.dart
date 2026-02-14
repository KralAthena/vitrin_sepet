import 'package:flutter/material.dart';
import '../services/cart_store.dart';
import '../models/cart_item.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _checkOut(BuildContext context) {
    if (CartStore().totalItems == 0) return;
    
    // Simulate checkout
    CartStore().clearCart();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
            children: [
                Icon(Icons.check_circle, color: Colors.white), 
                SizedBox(width: 8), 
                Text('Siparişiniz alındı! Teşekkürler.')
            ]
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('Sepetim', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
            onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder<Map<String, CartItem>>(
        valueListenable: CartStore().cartNotifier,
        builder: (context, cartMap, child) {
          final items = cartMap.values.toList();
          
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey.shade400)
                  ),
                  const SizedBox(height: 24),
                  Text(
                      'Sepetiniz boş',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      'Hadi alışverişe başlayalım!',
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Alışverişe Dön'),
                  )
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  itemCount: items.length,
                  itemBuilder: (ctx, index) {
                    final item = items[index];
                    return CartItemTile(
                      cartItem: item,
                      onIncrement: () => CartStore().incrementQuantity(item.product),
                      onDecrement: () => CartStore().decrementQuantity(item.product),
                      onDelete: () => CartStore().deleteItem(item.product),
                    );
                  },
                ),
              ),
              
              // Totals Section
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      spreadRadius: 5,
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ara Toplam (${CartStore().totalItems} ürün)', style: TextStyle(color: Colors.grey.shade600)),
                        Text('\$${CartStore().totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Genel Toplam', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          '\$${CartStore().totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => _checkOut(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text('ÖDEMEYE GEÇ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 20)
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
