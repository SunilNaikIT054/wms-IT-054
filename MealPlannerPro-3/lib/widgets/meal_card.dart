import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;
  final bool isInCart;
  final bool isCompact;
  
  const MealCard({
    Key? key,
    required this.meal,
    required this.onTap,
    this.onAddToCart,
    this.isInCart = false,
    this.isCompact = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal image
            Stack(
              children: [
                // Image
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    meal.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Discount badge
                if (meal.hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${meal.discount.toInt()}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                
                // Labels
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Row(
                    children: [
                      if (meal.isVegetarian)
                        _buildLabel(
                          context,
                          'Vegetarian',
                          Icons.eco,
                          Colors.green,
                        ),
                        
                      if (meal.isVegan)
                        _buildLabel(
                          context,
                          'Vegan',
                          Icons.spa,
                          Colors.green[700]!,
                        ),
                        
                      if (meal.isGlutenFree)
                        _buildLabel(
                          context,
                          'Gluten-Free',
                          Icons.grain_outlined,
                          Colors.amber[800]!,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Meal details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal name
                  Text(
                    meal.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Rating
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber[700],
                      ),
                      
                      const SizedBox(width: 4),
                      
                      Text(
                        meal.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      
                      const SizedBox(width: 4),
                      
                      Text(
                        '(${meal.reviewCount})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Calories
                      Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: Colors.orange[700],
                      ),
                      
                      const SizedBox(width: 4),
                      
                      Text(
                        '${meal.calories} cal',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  if (!isCompact) ...[
                    const SizedBox(height: 8),
                    
                    // Description
                    Text(
                      meal.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  
                  const SizedBox(height: 8),
                  
                  // Price and add to cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${meal.displayPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          
                          if (meal.hasDiscount)
                            Text(
                              '\$${meal.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      
                      // Add to cart button
                      if (onAddToCart != null)
                        IconButton(
                          onPressed: onAddToCart,
                          icon: Icon(
                            isInCart
                                ? Icons.shopping_cart
                                : Icons.add_shopping_cart,
                            color: isInCart
                                ? Theme.of(context).primaryColor
                                : Colors.grey[700],
                          ),
                          tooltip: isInCart ? 'Go to cart' : 'Add to cart',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLabel(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          
          const SizedBox(width: 4),
          
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
