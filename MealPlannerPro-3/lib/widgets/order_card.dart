import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;
  
  const OrderCard({
    Key? key,
    required this.order,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Order icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getStatusIcon(order.status),
                      color: _getStatusColor(order.status),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Order details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order ID
                        Text(
                          'Order #${order.id.split('_').last}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Order date
                        Text(
                          '${_formatDate(order.orderDate)} - ${order.totalItems} item${order.totalItems > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        color: _getStatusColor(order.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // Order items preview
            SizedBox(
              height: 80,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: order.items.length > 4 ? 4 : order.items.length,
                itemBuilder: (context, index) {
                  if (index < 3 || order.items.length <= 4) {
                    final item = order.items[index];
                    return Container(
                      width: 64,
                      height: 64,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(item.meal.imageUrl),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) => const SizedBox(),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                        child: Text(
                          '×${item.quantity}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  } else {
                    // More items indicator
                    return Container(
                      width: 64,
                      height: 64,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '+${order.items.length - 3}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            
            const Divider(height: 1),
            
            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Delivery date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        _formatDate(order.deliveryDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  // Total
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        '\$${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.teal,
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
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.access_time;
      case 'Processing':
        return Icons.inventory;
      case 'Shipped':
        return Icons.local_shipping;
      case 'Delivered':
        return Icons.check_circle;
      case 'Cancelled':
        return Icons.cancel;
      default:
        return Icons.receipt_long;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      case 'Shipped':
        return Colors.indigo;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
