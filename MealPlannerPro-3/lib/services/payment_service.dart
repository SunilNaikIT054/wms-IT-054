import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../utils/constants.dart';

enum PaymentStatus {
  success,
  failed,
  pending,
  refunded,
  cancelled
}

class PaymentMethod {
  final String id;
  final String type; // 'card', 'paypal', etc.
  final String? lastFourDigits;
  final String? cardType;
  final String? expiryDate;
  final String? cardholderName;
  final bool isDefault;
  
  PaymentMethod({
    required this.id,
    required this.type,
    this.lastFourDigits,
    this.cardType,
    this.expiryDate,
    this.cardholderName,
    this.isDefault = false,
  });
  
  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      type: json['type'],
      lastFourDigits: json['last_four_digits'],
      cardType: json['card_type'],
      expiryDate: json['expiry_date'],
      cardholderName: json['cardholder_name'],
      isDefault: json['is_default'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'last_four_digits': lastFourDigits,
      'card_type': cardType,
      'expiry_date': expiryDate,
      'cardholder_name': cardholderName,
      'is_default': isDefault,
    };
  }
}

class PaymentService {
  final String _baseUrl = ApiConstants.baseUrl;
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
  };
  
  final bool _useMockData = true; // For development purposes
  final Uuid _uuid = Uuid();
  
  // Get saved payment methods
  Future<List<PaymentMethod>> getPaymentMethods(String token, String userId) async {
    if (_useMockData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Return mock payment methods
      return [
        PaymentMethod(
          id: 'pm_123456',
          type: 'card',
          lastFourDigits: '4242',
          cardType: 'Visa',
          expiryDate: '12/25',
          cardholderName: 'John Doe',
          isDefault: true,
        ),
        PaymentMethod(
          id: 'pm_789012',
          type: 'card',
          lastFourDigits: '1234',
          cardType: 'Mastercard',
          expiryDate: '10/24',
          cardholderName: 'John Doe',
          isDefault: false,
        ),
        PaymentMethod(
          id: 'pm_345678',
          type: 'paypal',
          isDefault: false,
        ),
      ];
    }
    
    final headers = {
      ..._defaultHeaders,
      'Authorization': 'Bearer $token',
    };
    
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$userId/payment-methods'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PaymentMethod.fromJson(json)).toList();
    } else {
      final errorData = jsonDecode(response.body);
      throw errorData['message'] ?? 'Failed to fetch payment methods. Please try again.';
    }
  }
  
  // Add new payment method
  Future<PaymentMethod> addPaymentMethod(
    String token,
    String userId,
    String type,
    Map<String, dynamic> paymentDetails,
  ) async {
    if (_useMockData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Create mock payment method
      return PaymentMethod(
        id: 'pm_${_uuid.v4().substring(0, 6)}',
        type: type,
        lastFourDigits: paymentDetails['card_number']?.substring(paymentDetails['card_number'].length - 4),
        cardType: _getCardType(paymentDetails['card_number'] ?? ''),
        expiryDate: paymentDetails['expiry_date'],
        cardholderName: paymentDetails['cardholder_name'],
        isDefault: paymentDetails['is_default'] ?? false,
      );
    }
    
    final headers = {
      ..._defaultHeaders,
      'Authorization': 'Bearer $token',
    };
    
    final body = {
      'type': type,
      'details': paymentDetails,
    };
    
    final response = await http.post(
      Uri.parse('$_baseUrl/users/$userId/payment-methods'),
      headers: headers,
      body: jsonEncode(body),
    );
    
    if (response.statusCode == 201) {
      return PaymentMethod.fromJson(jsonDecode(response.body));
    } else {
      final errorData = jsonDecode(response.body);
      throw errorData['message'] ?? 'Failed to add payment method. Please try again.';
    }
  }
  
  // Delete payment method
  Future<void> deletePaymentMethod(
    String token,
    String userId,
    String paymentMethodId,
  ) async {
    if (_useMockData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      return;
    }
    
    final headers = {
      ..._defaultHeaders,
      'Authorization': 'Bearer $token',
    };
    
    final response = await http.delete(
      Uri.parse('$_baseUrl/users/$userId/payment-methods/$paymentMethodId'),
      headers: headers,
    );
    
    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      throw errorData['message'] ?? 'Failed to delete payment method. Please try again.';
    }
  }
  
  // Set default payment method
  Future<void> setDefaultPaymentMethod(
    String token,
    String userId,
    String paymentMethodId,
  ) async {
    if (_useMockData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      return;
    }
    
    final headers = {
      ..._defaultHeaders,
      'Authorization': 'Bearer $token',
    };
    
    final body = {
      'is_default': true,
    };
    
    final response = await http.put(
      Uri.parse('$_baseUrl/users/$userId/payment-methods/$paymentMethodId/default'),
      headers: headers,
      body: jsonEncode(body),
    );
    
    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      throw errorData['message'] ?? 'Failed to set default payment method. Please try again.';
    }
  }
  
  // Process payment
  Future<Map<String, dynamic>> processPayment(
    String token,
    String userId,
    String paymentMethodId,
    double amount,
    String currency,
    String description,
    Map<String, dynamic>? metadata,
  ) async {
    if (_useMockData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Return mock payment response
      return {
        'id': 'tx_${_uuid.v4().substring(0, 8)}',
        'amount': amount,
        'currency': currency,
        'status': 'succeeded',
        'payment_method': {
          'id': paymentMethodId,
          'type': 'card',
          'last_four_digits': '4242',
          'card_type': 'Visa',
        },
        'created_at': DateTime.now().toIso8601String(),
        'description': description,
        'metadata': metadata,
      };
    }
    
    final headers = {
      ..._defaultHeaders,
      'Authorization': 'Bearer $token',
    };
    
    final body = {
      'payment_method_id': paymentMethodId,
      'amount': amount,
      'currency': currency,
      'description': description,
      if (metadata != null) 'metadata': metadata,
    };
    
    final response = await http.post(
      Uri.parse('$_baseUrl/payments/process'),
      headers: headers,
      body: jsonEncode(body),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw errorData['message'] ?? 'Failed to process payment. Please try again.';
    }
  }
  
  // Get payment transaction details
  Future<Map<String, dynamic>> getPaymentTransaction(
    String token,
    String transactionId,
  ) async {
    if (_useMockData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Return mock transaction details
      return {
        'id': transactionId,
        'amount': 69.99,
        'currency': 'USD',
        'status': 'succeeded',
        'payment_method': {
          'id': 'pm_123456',
          'type': 'card',
          'last_four_digits': '4242',
          'card_type': 'Visa',
        },
        'created_at': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'description': 'Payment for Essential Meal Plan subscription',
        'metadata': {
          'subscription_id': 'sub_1',
          'user_id': 'user_123',
        },
      };
    }
    
    final headers = {
      ..._defaultHeaders,
      'Authorization': 'Bearer $token',
    };
    
    final response = await http.get(
      Uri.parse('$_baseUrl/payments/transactions/$transactionId'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw errorData['message'] ?? 'Failed to fetch payment details. Please try again.';
    }
  }
  
  // Refund payment
  Future<Map<String, dynamic>> refundPayment(
    String token,
    String transactionId,
    double? amount,
    String? reason,
  ) async {
    if (_useMockData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Return mock refund response
      return {
        'id': 're_${_uuid.v4().substring(0, 8)}',
        'transaction_id': transactionId,
        'amount': amount ?? 69.99,
        'currency': 'USD',
        'status': 'succeeded',
        'reason': reason ?? 'customer_requested',
        'created_at': DateTime.now().toIso8601String(),
      };
    }
    
    final headers = {
      ..._defaultHeaders,
      'Authorization': 'Bearer $token',
    };
    
    final body = {
      'transaction_id': transactionId,
      if (amount != null) 'amount': amount,
      if (reason != null) 'reason': reason,
    };
    
    final response = await http.post(
      Uri.parse('$_baseUrl/payments/refund'),
      headers: headers,
      body: jsonEncode(body),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw errorData['message'] ?? 'Failed to process refund. Please try again.';
    }
  }
  
  // Calculate taxes
  Future<Map<String, dynamic>> calculateTaxes(
    String token,
    double amount,
    Address billingAddress,
  ) async {
    if (_useMockData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Return mock tax calculation
      final taxRate = 0.0725; // 7.25% tax rate for example
      final taxAmount = amount * taxRate;
      
      return {
        'amount': amount,
        'tax_amount': taxAmount,
        'total_amount': amount + taxAmount,
        'tax_rate': taxRate,
        'tax_details': {
          'state_tax': taxAmount * 0.7,
          'local_tax': taxAmount * 0.3,
        },
        'billing_address': billingAddress.toJson(),
      };
    }
    
    final headers = {
      ..._defaultHeaders,
      'Authorization': 'Bearer $token',
    };
    
    final body = {
      'amount': amount,
      'billing_address': billingAddress.toJson(),
    };
    
    final response = await http.post(
      Uri.parse('$_baseUrl/payments/calculate-taxes'),
      headers: headers,
      body: jsonEncode(body),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw errorData['message'] ?? 'Failed to calculate taxes. Please try again.';
    }
  }
  
  // Apply promotion code
  Future<Map<String, dynamic>> applyPromoCode(
    String token,
    String promoCode,
    double amount,
    String? subscriptionPlanId,
  ) async {
    if (_useMockData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Check if it's a valid promo code (for demo purposes)
      if (promoCode.toUpperCase() == 'WELCOME20') {
        final discountAmount = amount * 0.2; // 20% off
        
        return {
          'original_amount': amount,
          'discount_amount': discountAmount,
          'final_amount': amount - discountAmount,
          'promo_code': promoCode,
          'discount_type': 'percentage',
          'discount_value': 20,
          'is_valid': true,
          'expiry_date': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        };
      } else {
        throw 'Invalid promotion code. Please try again.';
      }
    }
    
    final headers = {
      ..._defaultHeaders,
      'Authorization': 'Bearer $token',
    };
    
    final body = {
      'promo_code': promoCode,
      'amount': amount,
      if (subscriptionPlanId != null) 'subscription_plan_id': subscriptionPlanId,
    };
    
    final response = await http.post(
      Uri.parse('$_baseUrl/payments/apply-promo'),
      headers: headers,
      body: jsonEncode(body),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw errorData['message'] ?? 'Failed to apply promotion code. Please try again.';
    }
  }
  
  // Helper method to determine card type from number
  String _getCardType(String cardNumber) {
    // Remove spaces and dashes
    cardNumber = cardNumber.replaceAll(RegExp(r'[\s-]'), '');
    
    // Visa
    if (RegExp(r'^4').hasMatch(cardNumber)) {
      return 'Visa';
    }
    
    // Mastercard
    if (RegExp(r'^5[1-5]').hasMatch(cardNumber)) {
      return 'Mastercard';
    }
    
    // American Express
    if (RegExp(r'^3[47]').hasMatch(cardNumber)) {
      return 'American Express';
    }
    
    // Discover
    if (RegExp(r'^(6011|65|64[4-9])').hasMatch(cardNumber)) {
      return 'Discover';
    }
    
    return 'Unknown';
  }
}
