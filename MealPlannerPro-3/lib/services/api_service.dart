import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import 'mock_data_service.dart';

class ApiService {
  final String baseUrl = 'https://api.mealawe.com/v1';
  final bool _useMockData = true; // Set to false when real API is available
  final MockDataService _mockDataService = MockDataService();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    if (_useMockData) {
      return _mockDataService.login(email: email, password: password);
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
  }) async {
    if (_useMockData) {
      return _mockDataService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
      );
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          if (phone != null) 'phone': phone,
          if (address != null) 'address': address,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    if (_useMockData) {
      return _mockDataService.forgotPassword(email: email);
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
    required String token,
    required String name,
    String? phone,
    String? address,
  }) async {
    if (_useMockData) {
      return _mockDataService.updateUserProfile(
        userId: userId,
        token: token,
        name: name,
        phone: phone,
        address: address,
      );
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          if (phone != null) 'phone': phone,
          if (address != null) 'address': address,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String userId,
    required String token,
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_useMockData) {
      return _mockDataService.changePassword(
        userId: userId,
        token: token,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$userId/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> fetchMeals() async {
    if (_useMockData) {
      return _mockDataService.fetchMeals();
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/meals'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> fetchMealDetails(String mealId) async {
    if (_useMockData) {
      return _mockDataService.fetchMealDetails(mealId);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/meals/$mealId'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> fetchMealPlans() async {
    if (_useMockData) {
      return _mockDataService.fetchMealPlans();
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/meal-plans'),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> fetchUserSubscription({
    required String userId,
    required String token,
  }) async {
    if (_useMockData) {
      return _mockDataService.fetchUserSubscription(
        userId: userId,
        token: token,
      );
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/subscription'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> createSubscription({
    required String planId,
    required String userId,
    required String token,
    required String deliveryDay,
    required String paymentMethod,
  }) async {
    if (_useMockData) {
      return _mockDataService.createSubscription(
        planId: planId,
        userId: userId,
        token: token,
        deliveryDay: deliveryDay,
        paymentMethod: paymentMethod,
      );
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/subscriptions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'plan_id': planId,
          'user_id': userId,
          'delivery_day': deliveryDay,
          'payment_method': paymentMethod,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> cancelSubscription({
    required String subscriptionId,
    required String userId,
    required String token,
  }) async {
    if (_useMockData) {
      return _mockDataService.cancelSubscription(
        subscriptionId: subscriptionId,
        userId: userId,
        token: token,
      );
    }

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/subscriptions/$subscriptionId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> updateSubscription({
    required String subscriptionId,
    required String newPlanId,
    required String userId,
    required String token,
    required String deliveryDay,
    required String paymentMethod,
  }) async {
    if (_useMockData) {
      return _mockDataService.updateSubscription(
        subscriptionId: subscriptionId,
        newPlanId: newPlanId,
        userId: userId,
        token: token,
        deliveryDay: deliveryDay,
        paymentMethod: paymentMethod,
      );
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/subscriptions/$subscriptionId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'plan_id': newPlanId,
          'delivery_day': deliveryDay,
          'payment_method': paymentMethod,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> fetchUserOrders({
    required String userId,
    required String token,
  }) async {
    if (_useMockData) {
      return _mockDataService.fetchUserOrders(
        userId: userId,
        token: token,
      );
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/orders'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> placeOrder({
    required String userId,
    required String token,
    required List<OrderItem> items,
    required double subtotal,
    required double tax,
    required double deliveryFee,
    required double total,
    required String deliveryAddress,
    required DateTime deliveryDate,
    required String deliveryTime,
  }) async {
    if (_useMockData) {
      return _mockDataService.placeOrder(
        userId: userId,
        token: token,
        items: items,
        subtotal: subtotal,
        tax: tax,
        deliveryFee: deliveryFee,
        total: total,
        deliveryAddress: deliveryAddress,
        deliveryDate: deliveryDate,
        deliveryTime: deliveryTime,
      );
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': userId,
          'items': items.map((item) => {
                'meal_id': item.meal.id,
                'quantity': item.quantity,
                'price': item.price,
              }).toList(),
          'subtotal': subtotal,
          'tax': tax,
          'delivery_fee': deliveryFee,
          'total': total,
          'delivery_address': deliveryAddress,
          'delivery_date': deliveryDate.toIso8601String(),
          'delivery_time': deliveryTime,
          'status': 'Pending',
          'payment_method': 'Credit Card', // Default payment method
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> cancelOrder({
    required String orderId,
    required String userId,
    required String token,
  }) async {
    if (_useMockData) {
      return _mockDataService.cancelOrder(
        orderId: orderId,
        userId: userId,
        token: token,
      );
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/orders/$orderId/cancel'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}
