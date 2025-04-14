import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/order_card.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    if (authProvider.isLoggedIn) {
      await orderProvider.fetchUserOrders(
        userId: authProvider.user!.id,
        token: authProvider.token!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    // If not logged in
    if (!authProvider.isLoggedIn) {
      return _buildNotLoggedInView();
    }

    // If loading
    if (orderProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order History'),
        ),
        body: const Center(
          child: LoadingIndicator(),
        ),
      );
    }

    // If error
    if (orderProvider.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order History'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                orderProvider.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadOrders,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // If no orders
    if (orderProvider.orders.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order History'),
        ),
        body: _buildEmptyOrdersView(),
      );
    }

    // Default view with orders
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterOptions(context),
            tooltip: 'Filter',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadOrders,
        child: _buildOrdersList(orderProvider.orders),
      ),
    );
  }

  Widget _buildNotLoggedInView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle_outlined,
              size: 100,
              color: Colors.grey,
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Not Logged In',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Please log in to view your order history',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 32),
            
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to login screen
                // TODO: Implement navigation to login screen
              },
              icon: const Icon(Icons.login),
              label: const Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyOrdersView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'No Orders Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Your order history will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 24),
          
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to home/browse screen
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.restaurant_menu),
            label: const Text('Browse Meals'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onTap: () => _showOrderDetails(context, order),
        );
      },
    );
  }

  void _showOrderDetails(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sheet handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                // Order header
                Row(
                  children: [
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
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${order.id}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 4),
                          
                          Text(
                            _formatDate(order.orderDate),
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
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
                
                const SizedBox(height: 24),
                
                // Order items
                const Text(
                  'Order Items',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                ...order.items.map((item) => _buildOrderItemRow(item)),
                
                const SizedBox(height: 24),
                
                // Divider
                const Divider(),
                
                const SizedBox(height: 16),
                
                // Order summary
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Subtotal
                _buildSummaryRow(
                  label: 'Subtotal',
                  value: '\$${order.subtotal.toStringAsFixed(2)}',
                ),
                
                // Tax
                _buildSummaryRow(
                  label: 'Tax',
                  value: '\$${order.tax.toStringAsFixed(2)}',
                ),
                
                // Delivery fee
                _buildSummaryRow(
                  label: 'Delivery Fee',
                  value: order.deliveryFee > 0
                      ? '\$${order.deliveryFee.toStringAsFixed(2)}'
                      : 'FREE',
                  valueColor: order.deliveryFee > 0 ? null : Colors.green,
                ),
                
                // Total
                _buildSummaryRow(
                  label: 'Total',
                  value: '\$${order.total.toStringAsFixed(2)}',
                  isTotal: true,
                ),
                
                const SizedBox(height: 24),
                
                // Divider
                const Divider(),
                
                const SizedBox(height: 16),
                
                // Delivery information
                const Text(
                  'Delivery Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Delivery address
                _buildInfoRow(
                  icon: Icons.location_on,
                  label: 'Delivery Address',
                  value: order.deliveryAddress,
                ),
                
                const SizedBox(height: 8),
                
                // Delivery date
                _buildInfoRow(
                  icon: Icons.calendar_today,
                  label: 'Delivery Date',
                  value: _formatDate(order.deliveryDate),
                ),
                
                const SizedBox(height: 8),
                
                // Delivery time
                _buildInfoRow(
                  icon: Icons.access_time,
                  label: 'Delivery Time',
                  value: order.deliveryTime,
                ),
                
                const SizedBox(height: 24),
                
                // Divider
                const Divider(),
                
                const SizedBox(height: 16),
                
                // Payment information
                const Text(
                  'Payment Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Payment method
                _buildInfoRow(
                  icon: Icons.payment,
                  label: 'Payment Method',
                  value: order.paymentMethod,
                ),
                
                const SizedBox(height: 32),
                
                // Action buttons
                Row(
                  children: [
                    // Track order button
                    if (order.status != 'Delivered' && order.status != 'Cancelled')
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement track order functionality
                          },
                          icon: const Icon(Icons.local_shipping),
                          label: const Text('Track Order'),
                        ),
                      ),
                    
                    if (order.status != 'Delivered' && order.status != 'Cancelled')
                      const SizedBox(width: 16),
                    
                    // Reorder button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context); // Close bottom sheet
                          _reorder(context, order);
                        },
                        icon: const Icon(Icons.replay),
                        label: const Text('Reorder'),
                      ),
                    ),
                  ],
                ),
                
                // Cancel button (only for pending orders)
                if (order.status == 'Pending' || order.status == 'Processing')
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context); // Close bottom sheet
                          _showCancelOrderDialog(context, order);
                        },
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        label: const Text(
                          'Cancel Order',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItemRow(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meal image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.meal.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
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
                Text(
                  item.meal.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  '${item.quantity} x \$${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Item total
          Text(
            '\$${(item.quantity * item.price).toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
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
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: valueColor ?? (isTotal ? Colors.black : Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        
        const SizedBox(width: 12),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 4),
              
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFilterOptions(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Title
              const Text(
                'Filter Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Filter options
              const Text(
                'Status',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Status filters
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: orderProvider.statusFilter == null,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          orderProvider.setStatusFilter(null);
                        });
                      }
                    },
                  ),
                  FilterChip(
                    label: const Text('Pending'),
                    selected: orderProvider.statusFilter == 'Pending',
                    onSelected: (selected) {
                      setState(() {
                        orderProvider.setStatusFilter(selected ? 'Pending' : null);
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('Processing'),
                    selected: orderProvider.statusFilter == 'Processing',
                    onSelected: (selected) {
                      setState(() {
                        orderProvider.setStatusFilter(selected ? 'Processing' : null);
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('Shipped'),
                    selected: orderProvider.statusFilter == 'Shipped',
                    onSelected: (selected) {
                      setState(() {
                        orderProvider.setStatusFilter(selected ? 'Shipped' : null);
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('Delivered'),
                    selected: orderProvider.statusFilter == 'Delivered',
                    onSelected: (selected) {
                      setState(() {
                        orderProvider.setStatusFilter(selected ? 'Delivered' : null);
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('Cancelled'),
                    selected: orderProvider.statusFilter == 'Cancelled',
                    onSelected: (selected) {
                      setState(() {
                        orderProvider.setStatusFilter(selected ? 'Cancelled' : null);
                      });
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Date range
              const Text(
                'Date Range',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Date range filters
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text('All Time'),
                    selected: orderProvider.dateRangeFilter == null,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          orderProvider.setDateRangeFilter(null);
                        });
                      }
                    },
                  ),
                  FilterChip(
                    label: const Text('Last 30 Days'),
                    selected: orderProvider.dateRangeFilter == 30,
                    onSelected: (selected) {
                      setState(() {
                        orderProvider.setDateRangeFilter(selected ? 30 : null);
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('Last 90 Days'),
                    selected: orderProvider.dateRangeFilter == 90,
                    onSelected: (selected) {
                      setState(() {
                        orderProvider.setDateRangeFilter(selected ? 90 : null);
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('This Year'),
                    selected: orderProvider.dateRangeFilter == 365,
                    onSelected: (selected) {
                      setState(() {
                        orderProvider.setDateRangeFilter(selected ? 365 : null);
                      });
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Apply and clear buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          orderProvider.setStatusFilter(null);
                          orderProvider.setDateRangeFilter(null);
                        });
                      },
                      child: const Text('Clear All'),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        orderProvider.applyFilters();
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelOrderDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text(
          'Are you sure you want to cancel this order? This action cannot be undone.',
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
                      Text('Cancelling order...'),
                    ],
                  ),
                ),
              );
              
              // Cancel order
              final orderProvider = Provider.of<OrderProvider>(context, listen: false);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              
              final success = await orderProvider.cancelOrder(
                orderId: order.id,
                userId: authProvider.user!.id,
                token: authProvider.token!,
              );
              
              // Close loading dialog
              Navigator.pop(context);
              
              // Show result
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? 'Order cancelled successfully'
                        : orderProvider.errorMessage ?? 'Failed to cancel order',
                  ),
                  backgroundColor: success ? Colors.green : Colors.red,
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

  void _reorder(BuildContext context, Order order) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.reorder(order);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Items added to cart'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigate to cart
    // TODO: Navigate to cart or checkout screen
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
