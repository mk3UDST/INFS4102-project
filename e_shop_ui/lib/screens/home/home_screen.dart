// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:e_shop_ui/api/category_api.dart';
import 'package:e_shop_ui/api/product_api.dart';
import 'package:e_shop_ui/models/category.dart' as category_model;
import 'package:e_shop_ui/models/product.dart';
import 'package:e_shop_ui/components/product_card.dart';
import 'package:e_shop_ui/components/category_card.dart';
import 'package:e_shop_ui/screens/cart/cart_screen.dart'; // Ensure CartScreen is correctly referenced
import 'package:e_shop_ui/screens/orders/order_history_screen.dart';
import 'package:e_shop_ui/screens/profile/profile_screen.dart'; // Import ProfileScreen
import 'package:e_shop_ui/screens/products/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<category_model.Category>>? _categoriesFuture;
  Future<List<Product>>? _featuredProductsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _categoriesFuture = CategoryApi.getAllCategories();
    _featuredProductsFuture = ProductApi.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-Shop',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartScreen(),
                ), // Ensure CartScreen is correctly referenced
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ), // Ensure ProfileScreen is correctly referenced
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'user@example.com',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt_long),
              title: Text('My Orders'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => OrderHistoryScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadData();
          });
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        // Do nothing or navigate elsewhere
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),

                // Banner
                Container(
                  height: 180,
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(
                      context,
                    ).primaryColor.withOpacity(0.2), // Use this as fallback
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'New Collection',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Discount up to 30%',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Removed navigation to ProductListScreen (New Collection)
                              // Display a message instead
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Feature coming soon!')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            child: Text('Shop Now'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Categories section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Removed the "View All" button
                    ],
                  ),
                ),

                SizedBox(height: 10),

                // Categories List - Adjusted height
                SizedBox(
                  height: 80, // Increased from 20px to prevent overflow
                  child: FutureBuilder<List<category_model.Category>>(
                    future: _categoriesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error loading categories'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No categories available'));
                      }

                      final categories = snapshot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                        ), // Reduced horizontal padding
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: 8,
                            ), // Reduced spacing between items
                            child: CategoryCard(
                              category: category,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Feature coming soon!'),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),

                // Featured Products Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Products',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Removed the "View All" button
                    ],
                  ),
                ),

                SizedBox(height: 10),

                // Featured Products Grid - Display all products in 3 columns
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FutureBuilder<List<Product>>(
                    future: _featuredProductsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading products: ${snapshot.error}',
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text('No products available'),
                          ),
                        );
                      }

                      final products = snapshot.data!;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // 3 items per row
                              childAspectRatio:
                                  0.8, // Adjusted for better proportions
                              crossAxisSpacing: 8,
                              mainAxisSpacing:
                                  12, // Increased spacing between rows
                            ),
                        itemCount: products.length, // Display all products
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: products[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ProductDetailScreen(
                                        product: products[index],
                                      ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

                // Add less bottom padding
                SizedBox(height: 10), // Reduced from 20
              ],
            ),
          ),
        ),
      ),
    );
  }
}
