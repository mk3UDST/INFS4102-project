// lib/screens/products/product_list_screen.dart
import 'package:flutter/material.dart';
import 'package:e_shop_ui/api/product_api.dart';
import 'package:e_shop_ui/models/product.dart';
import 'package:e_shop_ui/components/product_card.dart';

class ProductListScreen extends StatefulWidget {
  final int? categoryId;
  
  const ProductListScreen({Key? key, this.categoryId, required bool isNewCollection, required bool isFeatured}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productsFuture;
  String _sortOption = 'name_asc';
  double _minPrice = 0.0;
  double _maxPrice = 1000.0;
  
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }
  
  void _loadProducts() {
    if (widget.categoryId != null) {
      _productsFuture = ProductApi.getProductsByCategory(widget.categoryId!);
    } else {
      _productsFuture = ProductApi.getAllProducts();
    }
  }
  
  void _applyFilters() {
    _productsFuture = ProductApi.filterProducts(
      categoryId: widget.categoryId,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      sortBy: _sortOption,
    );
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          }
          
          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ProductCard(product: snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
  
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Filter Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  
                  Text('Price Range', style: TextStyle(fontWeight: FontWeight.w600)),
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    labels: RangeLabels("\$${_minPrice.toInt()}", "\$${_maxPrice.toInt()}"),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                  
                  Text('Sort By', style: TextStyle(fontWeight: FontWeight.w600)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _sortOption,
                    items: [
                      DropdownMenuItem(value: 'name_asc', child: Text('Name (A-Z)')),
                      DropdownMenuItem(value: 'name_desc', child: Text('Name (Z-A)')),
                      DropdownMenuItem(value: 'price_asc', child: Text('Price (Low to High)')),
                      DropdownMenuItem(value: 'price_desc', child: Text('Price (High to Low)')),
                    ],
                    onChanged: (value) {
                      setState(() => _sortOption = value!);
                    },
                  ),
                  
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _applyFilters();
                    },
                    child: Text('Apply Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}