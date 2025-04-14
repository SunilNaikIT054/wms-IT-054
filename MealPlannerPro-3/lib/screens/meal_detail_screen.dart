import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/loading_indicator.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({
    Key? key,
    required this.mealId,
  }) : super(key: key);

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Meal?>(
        future: Provider.of<MealProvider>(context, listen: false)
            .fetchMealById(widget.mealId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingIndicator(),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    snapshot.error?.toString() ?? 'Failed to load meal details',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          final meal = snapshot.data!;
          return _buildContent(context, meal);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Meal meal) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Stack(
          children: [
            // Scrollable content
            CustomScrollView(
              slivers: [
                // Image and app bar
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 300,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Meal image
                        Image.network(
                          meal.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.image_not_supported, size: 60),
                              ),
                            );
                          },
                        ),
                        
                        // Gradient overlay for better text visibility
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black54,
                              ],
                              stops: [0.7, 1.0],
                            ),
                          ),
                        ),
                        
                        // Discount badge
                        if (meal.hasDiscount)
                          Positioned(
                            top: 80, // Adjusted to account for app bar
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${meal.savings}% OFF',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    // Cart button with badge
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigate to cart screen
                            // TODO: Implement navigation to cart
                          },
                        ),
                        if (cartProvider.totalItemCount > 0)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                cartProvider.totalItemCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                
                // Main content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                meal.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${meal.rating} (${meal.reviewCount} reviews)',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Price
                        Row(
                          children: [
                            Text(
                              '\$${meal.displayPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            if (meal.hasDiscount)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  '\$${meal.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Quick info chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildInfoChip(
                              icon: Icons.access_time,
                              label: meal.cookTime,
                            ),
                            _buildInfoChip(
                              icon: Icons.local_fire_department,
                              label: '${meal.calories} cal',
                            ),
                            ...meal.tags.map((tag) => _buildTagChip(tag)).toList(),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          meal.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Ingredients
                        const Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: meal.ingredients.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.fiber_manual_record,
                                    size: 12,
                                    color: Colors.teal,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      meal.ingredients[index],
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Nutrition facts
                        const Text(
                          'Nutrition Facts',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: meal.nutritionFacts.entries.map((entry) {
                            return Container(
                              width: MediaQuery.of(context).size.width / 2 - 24,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.value,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        
                        // Space for bottom button
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Bottom bar with add to cart button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Quantity selector
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: _decrementQuantity,
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            iconSize: 20,
                          ),
                          SizedBox(
                            width: 30,
                            child: Text(
                              _quantity.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: _incrementQuantity,
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            iconSize: 20,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Add to cart button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: meal.isAvailable
                            ? () {
                                // Add to cart
                                for (var i = 0; i < _quantity; i++) {
                                  cartProvider.addToCart(meal);
                                }
                                
                                // Show confirmation
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '$_quantity ${_quantity > 1 ? 'items' : 'item'} added to cart',
                                    ),
                                    action: SnackBarAction(
                                      label: 'View Cart',
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // TODO: Navigate to cart screen
                                      },
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          meal.isAvailable
                              ? 'Add to Cart - \$${(meal.displayPrice * _quantity).toStringAsFixed(2)}'
                              : 'Out of Stock',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[700],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
