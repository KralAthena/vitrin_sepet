import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/cart_store.dart';
import '../widgets/product_card.dart';
import '../widgets/custom_switch.dart';
import 'cart_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  
  // State
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _errorMessage = '';
  
  // Filters
  String _selectedSource = 'fake';
  String _searchQuery = '';
  String? _selectedCategory;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _selectedCategory = null;
    });

    try {
      if (_selectedSource == 'fake') {
        _allProducts = await _apiService.fetchFakeStoreProducts();
      } else if (_selectedSource == 'dummy') {
        _allProducts = await _apiService.fetchDummyJsonProducts();
      } else {
        _allProducts = await _apiService.fetchWantApiProducts();
      }
      _applyFilters();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _allProducts = [];
        _filteredProducts = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<Product> temp = _allProducts;

    if (_searchQuery.isNotEmpty) {
      temp = temp
          .where((p) => p.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_selectedCategory != null) {
      temp = temp.where((p) => p.category == _selectedCategory).toList();
    }

    setState(() {
      _filteredProducts = temp;
    });
  }

  List<String> get _categories {
    return _allProducts.map((p) => p.category).toSet().toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('VitrinSepet', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        actions: [
          ValueListenableBuilder(
            valueListenable: CartStore().cartNotifier,
            builder: (ctx, cart, child) {
              final count = CartStore().totalItems;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CartScreen()),
                        );
                      },
                    ),
                    if (count > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            // 0. Banner (Only for WantAPI)
            if (_selectedSource == 'want')
              Container(
                width: double.infinity,
                color: Colors.deepPurple,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                     'https://wantapi.com/assets/banner.png',
                     height: 140, 
                     width: double.infinity,
                     fit: BoxFit.cover,
                     loadingBuilder: (ctx, child, progress) {
                       if (progress == null) return child;
                       return Container(
                         height: 140,
                         color: Colors.deepPurple.shade200,
                         child: const Center(
                            child: CircularProgressIndicator(color: Colors.white)
                         ),
                       );
                     },
                     errorBuilder: (ctx, _, __) => Container(
                         height: 140,
                         color: Colors.deepPurple.shade200,
                         child: const Center(child: Icon(Icons.broken_image, color: Colors.white)),
                     ),
                  ),
                ),
              ),

            // 1. Source Switcher (Improved Design)
            Container(
              color: Colors.deepPurple,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SourceSwitch(
                selectedSource: _selectedSource,
                onSourceChanged: (val) {
                  if (val != _selectedSource) {
                    setState(() {
                      _selectedSource = val;
                      _fetchProducts();
                    });
                  }
                },
              ),
            ),
            
            // 2. Search & View Toggle
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                   Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Ürün ara...',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                          _applyFilters();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isGridView = !_isGridView;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _isGridView ? Icons.grid_view_rounded : Icons.view_list_rounded,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. Category Chips
            if (!_isLoading && _errorMessage.isEmpty && _categories.isNotEmpty)
              Container(
                 color: Colors.white,
                 width: double.infinity,
                 padding: const EdgeInsets.only(bottom: 12),
                 child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildCategoryChip('Tümü', _selectedCategory == null, () {
                          if (_selectedCategory != null) {
                            setState(() {
                              _selectedCategory = null;
                            });
                            _applyFilters();
                          }
                      }),
                      ..._categories.map((cat) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _buildCategoryChip(cat, _selectedCategory == cat, () {
                            setState(() {
                                _selectedCategory = (_selectedCategory == cat) ? null : cat;
                            });
                            _applyFilters();
                        }),
                      )),
                    ],
                  ),
                ),
              ),

            // 4. Content Area
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, VoidCallback onTap) {
      return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: isSelected ? Colors.deepPurple : Colors.white,
                  border: Border.all(color: isSelected ? Colors.deepPurple : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected ? [
                    BoxShadow(color: Colors.deepPurple.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))
                  ] : [],
              ),
              child: Text(
                  label,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                  ),
              ),
          ),
      );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_rounded, color: Colors.red.shade300, size: 64),
              const SizedBox(height: 16),
              const Text(
                  'Bağlantı Hatası',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                  _errorMessage, 
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchProducts,
                icon: const Icon(Icons.refresh),
                label: const Text('Tekrar Dene'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (_filteredProducts.isEmpty) {
      return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                      'Ürün bulunamadı.',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
              ],
          ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: _isGridView 
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _filteredProducts.length,
            itemBuilder: (ctx, index) => ProductCard(
              product: _filteredProducts[index],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailScreen(product: _filteredProducts[index])),
              ),
            ),
          )
        : ListView.builder(
            itemCount: _filteredProducts.length,
            itemBuilder: (ctx, index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: 140,
                child: ProductCard(
                  product: _filteredProducts[index],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailScreen(product: _filteredProducts[index])),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
