import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal_plan.dart';
import '../providers/auth_provider.dart';
import '../providers/subscription_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_indicator.dart';

class SubscriptionScreen extends StatefulWidget {
  final String planId;

  const SubscriptionScreen({Key? key, required this.planId}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  int _deliveryDay = 1; // Default to Monday
  String _selectedPaymentMethod = 'Credit Card'; // Default payment method
  bool _isProcessing = false;

  // Days of the week for delivery selection
  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // Payment methods
  final List<String> _paymentMethods = [
    'Credit Card',
    'PayPal',
    'Apple Pay',
    'Google Pay',
  ];

  @override
  Widget build(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    // If plan not found
    if (!subscriptionProvider.mealPlans.any((plan) => plan.id == widget.planId)) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Subscription'),
        ),
        body: const Center(
          child: Text('Plan not found'),
        ),
      );
    }

    final plan = subscriptionProvider.mealPlans.firstWhere(
      (plan) => plan.id == widget.planId,
    );

    // Calculate yearly discount if it's a yearly plan
    final yearlyDiscount = plan.planDuration.toLowerCase().contains('year')
        ? plan.price * 0.2 // 20% discount for yearly
        : 0.0;
    
    final discountedPrice = plan.price - yearlyDiscount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
      ),
      body: _isProcessing
          ? const Center(child: LoadingIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  // Subscription form
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Plan heading
                          Text(
                            plan.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          
                          const SizedBox(height: 8),

                          // Plan price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '\$${discountedPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              
                              const SizedBox(width: 4),

                              Text(
                                '/${plan.billingFrequency}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          if (yearlyDiscount > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Text(
                                    '\$${plan.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  
                                  const SizedBox(width: 8),
                                  
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'SAVE 20%',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Plan details in a card
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Plan Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Meal count
                                  _buildDetailRow(
                                    icon: Icons.restaurant,
                                    title: 'Meals per Delivery',
                                    value: '${plan.mealCount} meals',
                                  ),
                                  
                                  const SizedBox(height: 12),
                                  
                                  // Delivery frequency
                                  _buildDetailRow(
                                    icon: Icons.calendar_today,
                                    title: 'Delivery Frequency',
                                    value: plan.deliveryFrequency,
                                  ),
                                  
                                  const SizedBox(height: 12),
                                  
                                  // Serving size
                                  _buildDetailRow(
                                    icon: Icons.people,
                                    title: 'Serving Size',
                                    value: '${plan.servingSize} person',
                                  ),
                                  
                                  const SizedBox(height: 12),
                                  
                                  // Plan duration
                                  _buildDetailRow(
                                    icon: Icons.access_time,
                                    title: 'Plan Duration',
                                    value: plan.planDuration,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Plan description
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          Text(
                            plan.description,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.grey[800],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Delivery preferences
                          const Text(
                            'Delivery Preferences',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Preferred delivery day
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Preferred Delivery Day'),
                              
                              const SizedBox(height: 8),
                              
                              // Delivery day selector
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(
                                  _daysOfWeek.length,
                                  (index) => ChoiceChip(
                                    label: Text(_daysOfWeek[index]),
                                    selected: _deliveryDay == index,
                                    onSelected: (selected) {
                                      setState(() {
                                        _deliveryDay = index;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Payment method
                          const Text(
                            'Payment Method',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Payment method selector
                          DropdownButtonFormField<String>(
                            value: _selectedPaymentMethod,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            items: _paymentMethods.map((method) {
                              return DropdownMenuItem<String>(
                                value: method,
                                child: Text(method),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedPaymentMethod = newValue;
                                });
                              }
                            },
                          ),

                          const SizedBox(height: 24),

                          // Terms and conditions
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: Colors.blue[50],
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.blue[800],
                                      ),
                                      
                                      const SizedBox(width: 8),
                                      
                                      Text(
                                        'Subscription Terms',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  Text(
                                    'By subscribing, you agree to our terms and conditions. You can cancel anytime. Your subscription will automatically renew at the end of each billing period.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Space for bottom button
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),

                  // Subscribe button
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
                    child: CustomButton(
                      text: 'Subscribe Now',
                      onPressed: () => _subscribe(
                        context,
                        plan,
                        authProvider,
                        subscriptionProvider,
                      ),
                      isFullWidth: true,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        
        const SizedBox(width: 12),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 2),
            
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _subscribe(
    BuildContext context,
    MealPlan plan,
    AuthProvider authProvider,
    SubscriptionProvider subscriptionProvider,
  ) async {
    // Check if user is logged in
    if (!authProvider.isLoggedIn) {
      _showLoginRequiredDialog(context);
      return;
    }

    // Validate the form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Create the subscription
    final success = await subscriptionProvider.createSubscription(
      planId: plan.id,
      userId: authProvider.user!.id,
      token: authProvider.token!,
      deliveryDay: _daysOfWeek[_deliveryDay],
      paymentMethod: _selectedPaymentMethod,
    );

    setState(() {
      _isProcessing = false;
    });

    if (success) {
      // Show confirmation dialog
      _showSubscriptionConfirmationDialog(context, plan);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            subscriptionProvider.errorMessage ?? 'Failed to create subscription',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text(
          'You need to be logged in to subscribe to a meal plan.',
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

  void _showSubscriptionConfirmationDialog(BuildContext context, MealPlan plan) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Subscription Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 64,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'You have successfully subscribed to ${plan.name}!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Your first delivery is scheduled for next ${_daysOfWeek[_deliveryDay]}.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to plans screen
              // TODO: Navigate to home or account screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
