class AppConstants {
  // App Settings
  static const String appName = 'MealAwe';
  static const String appVersion = '1.0.0';
  
  // API Endpoints
  static const String baseUrl = 'https://api.mealawe.com/api/v1';
  static const String authEndpoint = '$baseUrl/auth';
  static const String mealsEndpoint = '$baseUrl/meals';
  static const String plansEndpoint = '$baseUrl/plans';
  static const String ordersEndpoint = '$baseUrl/orders';
  static const String subscriptionsEndpoint = '$baseUrl/subscriptions';
  
  // Local Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String cartKey = 'cart_items';
  
  // Payment Settings
  static const String currencyCode = 'USD';
  static const String paymentMerchantId = 'MERCHANT_ID';
  static const double taxRate = 0.085; // 8.5%
  static const double deliveryFee = 4.99;
  
  // UI Settings
  static const int animationDuration = 300; // milliseconds
  static const double borderRadius = 12.0;
  
  // Error Messages
  static const String networkError = 'Network error. Please check your connection and try again.';
  static const String authError = 'Authentication failed. Please check your credentials and try again.';
  static const String generalError = 'Something went wrong. Please try again later.';
  
  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String signupSuccess = 'Account created successfully!';
  static const String orderSuccess = 'Your order has been placed successfully!';
  static const String subscriptionSuccess = 'Your subscription has been activated!';
  
  // Feature Flags
  static const bool enablePaymentGateway = true;
  static const bool enableAnalytics = true;
  static const bool enablePushNotifications = true;
}
