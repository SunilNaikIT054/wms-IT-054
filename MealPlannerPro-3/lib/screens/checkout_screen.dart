import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_button.dart';
import 'payment_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    // If cart is empty
    if (cartProvider.isEmpty) {
      return _buildEmptyCart(context);
    }

    return Scaffold(
      body: Column(
        children: [
          // Cart items list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final cartItem = cartProvider.items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Meal image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            cartItem.meal.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Meal details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Meal name
                              Text(
                                cartItem.meal.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              
                              const SizedBox(height: 4),
                              
                              // Price
                              Row(
                                children: [
                                  Text(
                                    '\$${cartItem.meal.displayPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  
                                  if (cartItem.meal.hasDiscount)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(
                                        '\$${cartItem.meal.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // Quantity selector
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        // Decrement button
                                        InkWell(
                                          onTap: () {
                                            cartProvider.decrementQuantity(cartItem.meal.id);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            child: const Icon(
                                              Icons.remove,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                        
                                        // Quantity
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Text(
                                            cartItem.quantity.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        
                                        // Increment button
                                        InkWell(
                                          onTap: () {
                                            cartProvider.incrementQuantity(cartItem.meal.id);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            child: const Icon(
                                              Icons.add,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const Spacer(),
                                  
                                  // Remove button
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      cartProvider.removeFromCart(cartItem.meal.id);
                                    },
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
              },
            ),
          ),
          
          // Order summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Subtotal
                _buildSummaryRow(
                  label: 'Subtotal',
                  value: '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                ),
                
                // Tax
                _buildSummaryRow(
                  label: 'Tax (8%)',
                  value: '\$${cartProvider.taxAmount.toStringAsFixed(2)}',
                ),
                
                // Delivery fee
                _buildSummaryRow(
                  label: 'Delivery Fee',
                  value: cartProvider.deliveryFee > 0
                      ? '\$${cartProvider.deliveryFee.toStringAsFixed(2)}'
                      : 'FREE',
                  valueColor: cartProvider.deliveryFee > 0
                      ? null
                      : Colors.green,
                ),
                
                const Divider(height: 24),
                
                // Total
                _buildSummaryRow(
                  label: 'Total',
                  value: '\$${cartProvider.grandTotal.toStringAsFixed(2)}',
                  isTotal: true,
                ),
                
                const SizedBox(height: 16),
                
                // Checkout button
                CustomButton(
                  text: 'Proceed to Payment',
                  onPressed: () {
                    if (authProvider.isLoggedIn) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentScreen(),
                        ),
                      );
                    } else {
                      // Show dialog to login or continue as guest
                      _showLoginDialog(context);
                    }
                  },
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Looks like you haven\'t added any meals to your cart yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 24),
          
          CustomButton(
            text: 'Browse Meals',
            onPressed: () {
              // Navigate to home/browse screen
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Icons.restaurant_menu,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: valueColor ?? (isTotal ? Colors.black : Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text(
          'Please log in to complete your purchase. Would you like to login now?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to login screen
              // TODO: Implement navigation to login screen
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
