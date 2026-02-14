import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_store.dart';
import 'cart_screen.dart';

class DetailScreen extends StatefulWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Simple animation hook could be added here if needed
  
  void _addToCart() {
    CartStore().addToCart(widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('${widget.product.title} sepete eklendi!'),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
            // Cart badge can go here directly or cleaner without it for focus. 
            // Let's add a clean share/fav icon typically found in catalogues
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black87),
                    onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CartScreen()),
                        );
                    },
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image with white background
            Container(
              height: 380,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(32, 80, 32, 40),
              color: Colors.white,
              child: Hero(
                tag: widget.product.id,
                child: Image.network(
                  widget.product.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            // Content
            Container(
                transform: Matrix4.translationValues(0, -20, 0),
                decoration: const BoxDecoration(
                    color: Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 16,
                            offset: Offset(0, -4),
                        )
                    ]
                ),
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                         child: Container(
                             width: 40, height: 4, 
                             decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))
                         )
                    ),
                    const SizedBox(height: 24),
                    
                    // Title & Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.title,
                            style: const TextStyle(
                                fontSize: 22, 
                                fontWeight: FontWeight.bold, 
                                height: 1.3,
                                color: Colors.black87
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${widget.product.price}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Tags & Rating
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.deepPurple.shade100),
                          ),
                          child: Text(
                            widget.product.category,
                            style: TextStyle(color: Colors.deepPurple.shade700, fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.product.rating}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                        ),
                        Text(
                          ' (Rating)',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        )
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    const Text(
                      'Ürün Açıklaması',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.product.description,
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.6),
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))
              ]
          ),
          padding: const EdgeInsets.all(24),
          child: SizedBox(
               width: double.infinity,
               height: 56,
               child: ElevatedButton(
                   onPressed: _addToCart,
                   style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.deepPurple,
                       foregroundColor: Colors.white,
                       elevation: 0,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                   ),
                   child: const Text('Sepete Ekle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
               ),
          ),
      ),
    );
  }
}
