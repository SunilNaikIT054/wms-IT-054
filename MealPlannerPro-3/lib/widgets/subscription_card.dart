import 'package:flutter/material.dart';
import '../models/meal_plan.dart';
import '../models/subscription.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final MealPlan plan;
  final VoidCallback onCancel;
  final VoidCallback onManage;
  
  const SubscriptionCard({
    Key? key,
    required this.subscription,
    required this.plan,
    required this.onCancel,
    required this.onManage,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        '${plan.mealCount} meals per ${plan.deliveryFrequency.toLowerCase()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
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
                    subscription.isActive ? 'ACTIVE' : 'INACTIVE',
                    style: TextStyle(
                      color: subscription.isActive
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subscription details
                _buildInfoRow(
                  context,
                  'Next billing date',
                  _formatDate(subscription.nextBillingDate),
                  Icons.calendar_today,
                ),
                
                const SizedBox(height: 12),
                
                _buildInfoRow(
                  context,
                  'Amount',
                  '\$${subscription.price.toStringAsFixed(2)}/${plan.billingFrequency}',
                  Icons.attach_money,
                ),
                
                const SizedBox(height: 12),
                
                _buildInfoRow(
                  context,
                  'Payment method',
                  subscription.paymentMethod,
                  Icons.payment,
                ),
                
                const SizedBox(height: 12),
                
                _buildInfoRow(
                  context,
                  'Started on',
                  _formatDate(subscription.startDate),
                  Icons.access_time,
                ),
                
                const SizedBox(height: 16),
                
                const Divider(),
                
                const SizedBox(height: 16),
                
                // Plan description
                Text(
                  plan.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onManage,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Manage'),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onCancel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
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
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 2),
            
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
