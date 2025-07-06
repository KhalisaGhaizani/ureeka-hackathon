// File: lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/rental_property.dart';
import '../screens/property_detail_screen.dart';
import '../screens/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<RentalProperty> _allProperties = [];
  List<RentalProperty> _filteredProperties = [];
  final List<RentalProperty> _cartItems = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeProperties();
    _filteredProperties = List.from(_allProperties);
  }

  void _initializeProperties() {
    _allProperties = [
      RentalProperty(
        id: '1',
        name: 'Rumah Mewah',
        location: 'Jakarta, Jakarta',
        price: 150.0,
        imageUrl: 'assets/images/home1.jpeg',
        description:
            'Sebuah rumah besar yang dilengkapi dengan kolam renang',
      ),
      RentalProperty(
        id: '2',
        name: 'Apartemen Tinggi',
        location: 'Alam Sutera, Tangerang Selatan',
        price: 300.0,
        imageUrl: 'assets/images/home2.webp',
        description:
            'Apartemen yang dilengkapi oleh kolam renang, gym, dan perpustakaan',
      ),
      RentalProperty(
        id: '3',
        name: 'Hotel Luas',
        location: 'Lampung',
        price: 200.0,
        imageUrl: 'assets/images/home3.jpg',
        description:
            'Sebuah hotel dengan fasilitas yang banyak dan super luas',
      ),
      RentalProperty(
        id: '4',
        name: 'Hotel Murah',
        location: 'Jakrta',
        price: 120.0,
        imageUrl: 'assets/images/home4.jpg',
        description:
            'Sebuah hotel dengan harga yang sangat kompetitif',
      ),
      RentalProperty(
        id: '5',
        name: 'Tempat Istirahat',
        location: 'Yogyakarta',
        price: 180.0,
        imageUrl: 'assets/images/home5.jpg',
        description: 'Tempat peristirahatan yang ideal saat sedang berperjalann jauh',
      ),
    ];
  }

  void _filterProperties(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredProperties = List.from(_allProperties);
      } else {
        _filteredProperties =
            _allProperties
                .where(
                  (property) =>
                      property.name.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      property.location.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();
      }
    });
  }

  void _addToCart(RentalProperty property) {
    setState(() {
      if (!_cartItems.any((item) => item.id == property.id)) {
        _cartItems.add(property);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${property.name} added to cart'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${property.name} is already in cart'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _removeFromCart(RentalProperty property) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == property.id);
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Rental Properties'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CartScreen(
                            cartItems: _cartItems,
                            onRemoveFromCart: _removeFromCart,
                            onClearCart: _clearCart,
                          ),
                    ),
                  );
                },
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${_cartItems.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterProperties,
              decoration: InputDecoration(
                hintText: 'Search properties...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterProperties('');
                          },
                        )
                        : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          // Properties List
          Expanded(
            child:
                _filteredProperties.isEmpty && _searchQuery.isNotEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No properties found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Try adjusting your search terms',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredProperties.length,
                      itemBuilder: (context, index) {
                        final property = _filteredProperties[index];
                        return PropertyCard(
                          property: property,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PropertyDetailScreen(
                                      property: property,
                                      onAddToCart: _addToCart,
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final RentalProperty property;
  final VoidCallback onTap;

  const PropertyCard({super.key, required this.property, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image(
                image: AssetImage(property.imageUrl),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.home,
                      size: 48,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${property.price.toStringAsFixed(0)}/night',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
