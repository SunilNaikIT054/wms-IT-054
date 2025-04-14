import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Filters
  String? _statusFilter;
  int? _dateRangeFilter;
  
  // Filter flags
  bool _hasAppliedFilters = false;
  List<Order> _unfilteredOrders = [];

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get statusFilter => _statusFilter;
  int? get dateRangeFilter => _dateRangeFilter;

  Future<void> fetchUserOrders({required String userId, required String token}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final apiService = ApiService();
      final response = await apiService.fetchUserOrders(userId: userId, token: token);

      if (response['success']) {
        _orders = (response['orders'] as List)
            .map((orderJson) => Order.fromJson(orderJson))
            .toList();
        
        // Sort orders by order date (newest first)
        _orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
        
        // Store unfiltered orders
        _unfilteredOrders = List.from(_orders);
        
        // Apply any existing filters
        if (_hasAppliedFilters) {
          _applyFilters();
        }
        
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        _errorMessage = response['message'] ?? 'Failed to fetch orders';
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch orders: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
    }
  }

  Future<Order?> placeOrder({
    required String userId,
    required String token,
    required CartProvider cart,
    required String deliveryAddress,
    required DateTime deliveryDate,
    required String deliveryTime,
  }) async {
    try {
      if (cart.isEmpty) {
        _errorMessage = 'Your cart is empty';
        notifyListeners();
        return null;
      }

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final orderItems = cart.items
          .map((item) => OrderItem(
                meal: item.meal,
                quantity: item.quantity,
                price: item.meal.displayPrice,
              ))
          .toList();

      final apiService = ApiService();
      final response = await apiService.placeOrder(
        userId: userId,
        token: token,
        items: orderItems,
        subtotal: cart.totalPrice,
        tax: cart.taxAmount,
        deliveryFee: cart.deliveryFee,
        total: cart.grandTotal,
        deliveryAddress: deliveryAddress,
        deliveryDate: deliveryDate,
        deliveryTime: deliveryTime,
      );

      _isLoading = false;

      if (response['success']) {
        final newOrder = Order.fromJson(response['order']);
        
        // Add the new order to the beginning of the list
        _orders.insert(0, newOrder);
        
        // Add to unfiltered orders as well
        _unfilteredOrders.insert(0, newOrder);
        
        notifyListeners();
        return newOrder;
      } else {
        _errorMessage = response['message'] ?? 'Failed to place order';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to place order: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
      return null;
    }
  }

  Future<bool> cancelOrder({
    required String orderId,
    required String userId,
    required String token,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final apiService = ApiService();
      final response = await apiService.cancelOrder(
        orderId: orderId,
        userId: userId,
        token: token,
      );

      _isLoading = false;

      if (response['success']) {
        // Update the order status in our list
        final index = _orders.indexWhere((order) => order.id == orderId);
        if (index >= 0) {
          final updatedOrder = _orders[index].copyWith(status: 'Cancelled');
          _orders[index] = updatedOrder;
          
          // Also update in unfiltered orders
          final unfilteredIndex = _unfilteredOrders.indexWhere((order) => order.id == orderId);
          if (unfilteredIndex >= 0) {
            _unfilteredOrders[unfilteredIndex] = updatedOrder;
          }
        }
        
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to cancel order';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to cancel order: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
      return false;
    }
  }

  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  void reorder(Order order) {
    // This will trigger adding all items from a previous order to the cart
    // The actual implementation will depend on how the Cart provider is structured
    // but this just signals the intent
    notifyListeners();
  }
  
  void setStatusFilter(String? status) {
    _statusFilter = status;
  }
  
  void setDateRangeFilter(int? days) {
    _dateRangeFilter = days;
  }
  
  void applyFilters() {
    _hasAppliedFilters = true;
    _applyFilters();
    notifyListeners();
  }
  
  void _applyFilters() {
    // Start with unfiltered orders
    _orders = List.from(_unfilteredOrders);
    
    // Apply status filter
    if (_statusFilter != null) {
      _orders = _orders.where((order) => order.status == _statusFilter).toList();
    }
    
    // Apply date range filter
    if (_dateRangeFilter != null) {
      final cutoffDate = DateTime.now().subtract(Duration(days: _dateRangeFilter!));
      _orders = _orders.where((order) => order.orderDate.isAfter(cutoffDate)).toList();
    }
  }
  
  void clearFilters() {
    _statusFilter = null;
    _dateRangeFilter = null;
    _hasAppliedFilters = false;
    _orders = List.from(_unfilteredOrders);
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
