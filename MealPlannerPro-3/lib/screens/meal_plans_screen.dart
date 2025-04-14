import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../widgets/plan_card.dart';
import '../widgets/loading_indicator.dart';
import 'subscription_screen.dart';

class MealPlansScreen extends StatelessWidget {
  const MealPlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    
    if (subscriptionProvider.isLoading) {
      return const Center(
        child: LoadingIndicator(),
      );
    }
    
    if (subscriptionProvider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              subscriptionProvider.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                subscriptionProvider.fetchMealPlans();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (subscriptionProvider.mealPlans.isEmpty) {
      return const Center(
        child: Text('No meal plans available at the moment'),
      );
    }
    
    // When user has an active subscription
    if (subscriptionProvider.hasActiveSubscription) {
      return _buildActiveSubscriptionView(context, subscriptionProvider);
    }
    
    // Default view: show available meal plans
    return RefreshIndicator(
      onRefresh: () => subscriptionProvider.fetchMealPlans(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Choose Your Meal Plan',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Select a plan that fits your needs and enjoy delicious, chef-prepared meals delivered to your door.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            const SizedBox(height: 24),
            
            // Popular plans
            const Text(
              'Popular Plans',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            ...subscriptionProvider.mealPlans
                .where((plan) => plan.isPopular)
                .map((plan) => PlanCard(
                      plan: plan,
                      onSubscribe: () => _navigateToSubscription(context, plan.id),
                    ))
                .toList(),
            
            const SizedBox(height: 24),
            
            // All available plans
            const Text(
              'All Plans',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            ...subscriptionProvider.mealPlans
                .where((plan) => !plan.isPopular)
                .map((plan) => PlanCard(
                      plan: plan,
                      onSubscribe: () => _navigateToSubscription(context, plan.id),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActiveSubscriptionView(BuildContext context, SubscriptionProvider subscriptionProvider) {
    final activePlan = subscriptionProvider.getActiveSubscriptionPlan();
    final subscription = subscriptionProvider.activeSubscription;
    
    if (activePlan == null || subscription == null) {
      return const Center(
        child: Text('Failed to load subscription information'),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Your Active Subscription',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          
          const SizedBox(height: 24),
          
          // Subscription card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with active badge
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          activePlan.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'ACTIVE',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Plan details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Next billing date
                      _buildInfoRow(
                        icon: Icons.calendar_today,
                        title: 'Next Billing Date',
                        value: '${subscription.nextBillingDate.month}/${subscription.nextBillingDate.day}/${subscription.nextBillingDate.year}',
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Amount
                      _buildInfoRow(
                        icon: Icons.attach_money,
                        title: 'Amount',
                        value: '\$${subscription.price.toStringAsFixed(2)}',
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Plan type
                      _buildInfoRow(
                        icon: Icons.access_time,
                        title: 'Plan Type',
                        value: activePlan.planDuration,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Meals per delivery
                      _buildInfoRow(
                        icon: Icons.restaurant,
                        title: 'Meals per Delivery',
                        value: '${activePlan.mealCount} meals',
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Payment method
                      _buildInfoRow(
                        icon: Icons.payment,
                        title: 'Payment Method',
                        value: subscription.paymentMethod,
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Divider
                      const Divider(),
                      
                      const SizedBox(height: 16),
                      
                      // Plan description
                      Text(
                        activePlan.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Manage subscription button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // TODO: Implement navigation to manage subscription screen
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('Manage Subscription'),
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // Cancel subscription button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _showCancelConfirmationDialog(context, subscriptionProvider);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('Cancel Subscription'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Available plans section
          const Text(
            'Other Available Plans',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          ...subscriptionProvider.mealPlans
              .where((plan) => plan.id != activePlan.id)
              .map((plan) => PlanCard(
                    plan: plan,
                    onSubscribe: () => _showChangeSubscriptionDialog(
                      context,
                      subscriptionProvider,
                      plan.id,
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow({
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
        const SizedBox(width: 16),
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
            const SizedBox(height: 4),
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
  
  void _navigateToSubscription(BuildContext context, String planId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubscriptionScreen(planId: planId),
      ),
    );
  }
  
  void _showCancelConfirmationDialog(
    BuildContext context,
    SubscriptionProvider subscriptionProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Subscription'),
        content: const Text(
          'Are you sure you want to cancel your subscription? This will take effect immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No, Keep It'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Cancelling subscription...'),
                    ],
                  ),
                ),
              );
              
              // Get auth token
              final authProvider = Provider.of<SubscriptionProvider>(context, listen: false);
              // TODO: Implement cancel subscription functionality
              
              // Close loading dialog
              Navigator.pop(context);
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Subscription cancelled successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
  
  void _showChangeSubscriptionDialog(
    BuildContext context,
    SubscriptionProvider subscriptionProvider,
    String newPlanId,
  ) {
    final newPlan = subscriptionProvider.mealPlans.firstWhere(
      (plan) => plan.id == newPlanId,
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Subscription'),
        content: Text(
          'Are you sure you want to change your subscription to ${newPlan.name}? Your existing subscription will be cancelled, and the new one will start immediately.',
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
              _navigateToSubscription(context, newPlanId);
            },
            child: const Text('Change Plan'),
          ),
        ],
      ),
    );
  }
}
