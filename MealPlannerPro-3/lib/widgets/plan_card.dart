import 'package:flutter/material.dart';
import '../models/meal_plan.dart';

class PlanCard extends StatelessWidget {
  final MealPlan plan;
  final VoidCallback onSubscribe;
  
  const PlanCard({
    Key? key,
    required this.plan,
    required this.onSubscribe,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isYearly = plan.planDuration.toLowerCase().contains('year');
    final discountedPrice = isYearly ? plan.price * 0.8 : plan.price; // 20% discount for yearly
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan header
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
                      
                      Row(
                        children: [
                          _buildInfoChip(
                            '${plan.mealCount} meals',
                            Icons.restaurant,
                          ),
                          
                          const SizedBox(width: 8),
                          
                          _buildInfoChip(
                            '${plan.servingSize} person',
                            Icons.person,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                if (plan.isPopular)
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
                      'POPULAR',
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
          
          // Plan content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '\$${discountedPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
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
                
                // Discount for yearly plans
                if (isYearly)
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
                
                const SizedBox(height: 12),
                
                // Description
                Text(
                  plan.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 16),
                
                // Features
                ...plan.features.map((feature) => _buildFeatureItem(feature)),
                
                const SizedBox(height: 16),
                
                // Subscribe button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSubscribe,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Choose Plan'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.white,
          ),
          
          const SizedBox(width: 4),
          
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            size: 18,
            color: Colors.green,
          ),
          
          const SizedBox(width: 8),
          
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
