import '../models/meal.dart';
import '../models/meal_plan.dart';
import '../models/order.dart';
import '../models/subscription.dart';
import '../models/user.dart';
import 'dart:math';

class MockDataService {
  final Random _random = Random();
  final Map<String, User> _users = {};
  final Map<String, String> _tokens = {};
  final Map<String, List<Order>> _userOrders = {};
  final Map<String, Subscription?> _userSubscriptions = {};

  // Generate a random ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Mock login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      return {
        'success': false,
        'message': 'Email and password are required',
      };
    }

    // Check if the user exists (for mock purposes, create if not)
    if (!_users.values.any((user) => user.email == email)) {
      if (email != 'test@example.com') {
        return {
          'success': false,
          'message': 'Invalid email or password',
        };
      }

      // Create a test user for demo purposes
      final userId = _generateId();
      final user = User(
        id: userId,
        name: 'Test User',
        email: email,
        phone: '555-123-4567',
        address: '123 Main St, Anytown, US 12345',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );

      _users[userId] = user;
      _tokens[userId] = 'mock_token_$userId';
      _userOrders[userId] = [];
      _userSubscriptions[userId] = null;
    }

    final user = _users.values.firstWhere((user) => user.email == email);
    final token = _tokens[user.id];

    return {
      'success': true,
      'user': user.toJson(),
      'token': token,
    };
  }

  // Mock registration
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
  }) async {
    // Simple validation
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return {
        'success': false,
        'message': 'Name, email, and password are required',
      };
    }

    // Check if the email is already in use
    if (_users.values.any((user) => user.email == email)) {
      return {
        'success': false,
        'message': 'Email is already in use',
      };
    }

    // Create a new user
    final userId = _generateId();
    final user = User(
      id: userId,
      name: name,
      email: email,
      phone: phone,
      address: address,
      createdAt: DateTime.now(),
    );

    _users[userId] = user;
    _tokens[userId] = 'mock_token_$userId';
    _userOrders[userId] = [];
    _userSubscriptions[userId] = null;

    return {
      'success': true,
      'user': user.toJson(),
      'token': _tokens[userId],
    };
  }

  // Mock forgot password
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    // Simple validation
    if (email.isEmpty) {
      return {
        'success': false,
        'message': 'Email is required',
      };
    }

    // Check if the user exists
    if (!_users.values.any((user) => user.email == email)) {
      // In a real app, you might not want to reveal if the email exists
      return {
        'success': false,
        'message': 'If your email is registered, you will receive a password reset link.',
      };
    }

    return {
      'success': true,
      'message': 'Password reset email has been sent. Please check your inbox.',
    };
  }

  // Mock update user profile
  Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
    required String token,
    required String name,
    String? phone,
    String? address,
  }) async {
    // Validate token (in a real app, this would be more sophisticated)
    if (_tokens[userId] != token) {
      return {
        'success': false,
        'message': 'Unauthorized',
      };
    }

    // Check if the user exists
    if (!_users.containsKey(userId)) {
      return {
        'success': false,
        'message': 'User not found',
      };
    }

    // Update the user
    final user = _users[userId]!;
    _users[userId] = user.copyWith(
      name: name,
      phone: phone,
      address: address,
    );

    return {
      'success': true,
      'user': _users[userId]!.toJson(),
    };
  }

  // Mock change password
  Future<Map<String, dynamic>> changePassword({
    required String userId,
    required String token,
    required String currentPassword,
    required String newPassword,
  }) async {
    // Validate token
    if (_tokens[userId] != token) {
      return {
        'success': false,
        'message': 'Unauthorized',
      };
    }

    // Check if the user exists
    if (!_users.containsKey(userId)) {
      return {
        'success': false,
        'message': 'User not found',
      };
    }

    // In a real app, you would verify the current password
    if (currentPassword.isEmpty) {
      return {
        'success': false,
        'message': 'Current password is required',
      };
    }

    // Validate the new password
    if (newPassword.length < 6) {
      return {
        'success': false,
        'message': 'New password must be at least 6 characters long',
      };
    }

    return {
      'success': true,
      'message': 'Password changed successfully',
    };
  }

  // Mock fetch meals
  Future<Map<String, dynamic>> fetchMeals() async {
    // Generate mock meals
    final List<Map<String, dynamic>> meals = [];

    // Categories
    final List<String> categories = [
      'Main Course',
      'Breakfast',
      'Lunch',
      'Dinner',
      'Dessert',
      'Salad',
      'Soup',
      'Appetizer',
    ];

    // Generate a variety of meals
    for (int i = 1; i <= 20; i++) {
      final bool isVegetarian = _random.nextBool();
      final bool isVegan = isVegetarian && _random.nextBool();
      final bool isGlutenFree = _random.nextBool();
      final bool isSpicy = _random.nextBool();
      
      final int calories = 200 + _random.nextInt(800);
      final double rating = 3.0 + _random.nextDouble() * 2.0;
      final int reviewCount = 10 + _random.nextInt(990);
      
      final String category = categories[_random.nextInt(categories.length)];
      
      final double price = 5.0 + (_random.nextInt(25) * 0.5);
      final double discount = _random.nextInt(10) > 7 ? 5.0 + (_random.nextInt(4) * 5.0) : 0.0;
      
      final String id = 'meal_$i';
      
      final String name = _getMockMealName(i, category, isVegetarian);
      
      meals.add({
        'id': id,
        'name': name,
        'description': 'Delicious ${isVegetarian ? 'vegetarian' : ''} ${isVegan ? 'vegan' : ''} ${isGlutenFree ? 'gluten-free' : ''} $category meal. Perfect for any occasion. ${isSpicy ? 'Spicy!' : ''}',
        'price': price,
        'discount': discount,
        'image_url': 'https://source.unsplash.com/random/300x200?food,${name.replaceAll(' ', ',')}',
        'ingredients': _getMockIngredients(isVegetarian, isVegan),
        'allergens': _getMockAllergens(isGlutenFree),
        'category': category,
        'nutritional_info': {
          'calories': '$calories cal',
          'protein': '${10 + _random.nextInt(30)}g',
          'carbs': '${20 + _random.nextInt(60)}g',
          'fat': '${5 + _random.nextInt(25)}g',
          'fiber': '${2 + _random.nextInt(10)}g',
        },
        'preparation_time': 10 + _random.nextInt(50),
        'is_spicy': isSpicy,
        'is_vegetarian': isVegetarian,
        'is_vegan': isVegan,
        'is_gluten_free': isGlutenFree,
        'calories': calories,
        'rating': rating,
        'review_count': reviewCount,
      });
    }

    return {
      'success': true,
      'meals': meals,
    };
  }

  // Helper for meal names
  String _getMockMealName(int index, String category, bool isVegetarian) {
    List<String> mealNames = [
      'Grilled Salmon',
      'Vegetable Stir Fry',
      'Chicken Alfredo Pasta',
      'Margherita Pizza',
      'Caesar Salad',
      'Beef Tacos',
      'Mushroom Risotto',
      'BBQ Ribs',
      'Sushi Platter',
      'Vegetable Curry',
      'Lasagna',
      'Beef Burger',
      'Teriyaki Chicken',
      'Ratatouille',
      'Tomato Soup',
      'Lobster Bisque',
      'Pancakes with Maple Syrup',
      'French Toast',
      'Greek Yogurt Bowl',
      'Avocado Toast',
      'Quinoa Salad',
      'Roasted Vegetable Wrap',
      'Lemon Cheesecake',
      'Chocolate Brownie',
      'Vanilla Ice Cream',
      'Apple Pie',
      'Mixed Berry Smoothie',
      'Acai Bowl',
      'Eggs Benedict',
      'Beef Stew',
    ];
    
    if (index < mealNames.length) {
      if (isVegetarian && mealNames[index].contains('Chicken') || mealNames[index].contains('Beef') || mealNames[index].contains('Salmon')) {
        return 'Vegetarian ' + mealNames[index].replaceAll('Chicken', 'Tofu').replaceAll('Beef', 'Mushroom').replaceAll('Salmon', 'Eggplant');
      }
      return mealNames[index];
    }
    
    return '$category Special #$index';
  }

  // Helper for ingredients
  List<String> _getMockIngredients(bool isVegetarian, bool isVegan) {
    List<String> baseIngredients = [
      'Salt', 'Pepper', 'Olive Oil', 'Garlic', 'Onion', 'Tomatoes',
      'Bell Peppers', 'Spinach', 'Carrots', 'Broccoli', 'Rice', 'Pasta',
      'Potatoes', 'Mushrooms', 'Herbs', 'Spices',
    ];
    
    List<String> nonVegIngredients = [
      'Chicken', 'Beef', 'Pork', 'Salmon', 'Shrimp', 'Tuna',
    ];
    
    List<String> dairyIngredients = [
      'Cheese', 'Butter', 'Cream', 'Milk', 'Yogurt',
    ];
    
    List<String> result = List.from(baseIngredients);
    
    if (!isVegetarian) {
      result.addAll(nonVegIngredients.sublist(0, 2 + _random.nextInt(3)));
    }
    
    if (!isVegan) {
      result.addAll(dairyIngredients.sublist(0, 1 + _random.nextInt(3)));
    }
    
    result.shuffle();
    return result.sublist(0, 5 + _random.nextInt(5));
  }

  // Helper for allergens
  List<String> _getMockAllergens(bool isGlutenFree) {
    List<String> possibleAllergens = [
      'Milk', 'Eggs', 'Fish', 'Shellfish', 'Tree Nuts', 'Peanuts', 
      'Wheat', 'Soybean', 'Sesame',
    ];
    
    List<String> result = [];
    
    // Add a random subset of allergens
    for (String allergen in possibleAllergens) {
      if (_random.nextInt(10) > 7) {
        if (isGlutenFree && allergen == 'Wheat') {
          continue; // Skip wheat for gluten-free meals
        }
        result.add(allergen);
      }
    }
    
    return result;
  }

  // Mock fetch meal details
  Future<Map<String, dynamic>> fetchMealDetails(String mealId) async {
    // Fetch all meals and find the one with the given ID
    final meals = await fetchMeals();
    if (!meals['success']) {
      return meals;
    }

    final mealsList = meals['meals'] as List;
    final meal = mealsList.firstWhere(
      (m) => m['id'] == mealId,
      orElse: () => null,
    );

    if (meal == null) {
      return {
        'success': false,
        'message': 'Meal not found',
      };
    }

    return {
      'success': true,
      'meal': meal,
    };
  }

  // Mock fetch meal plans
  Future<Map<String, dynamic>> fetchMealPlans() async {
    // Generate mock meal plans
    final List<Map<String, dynamic>> plans = [
      {
        'id': 'plan_1',
        'name': 'Basic Plan',
        'description': 'Perfect for individuals who want convenient, healthy meals delivered weekly. Enjoy chef-prepared meals with fresh ingredients.',
        'price': 49.99,
        'delivery_frequency': 'Weekly',
        'billing_frequency': 'week',
        'plan_duration': 'Monthly',
        'meal_count': 5,
        'serving_size': 1,
        'is_popular': false,
        'features': [
          '5 meals per week',
          'Free delivery',
          'No commitment - cancel anytime',
          'Weekly menu rotation'
        ],
      },
      {
        'id': 'plan_2',
        'name': 'Family Plan',
        'description': 'Designed for families, this plan includes a variety of meals that everyone will love. Save time on meal planning and grocery shopping.',
        'price': 89.99,
        'delivery_frequency': 'Weekly',
        'billing_frequency': 'week',
        'plan_duration': 'Monthly',
        'meal_count': 10,
        'serving_size': 4,
        'is_popular': true,
        'features': [
          '10 family-size meals per week',
          'Free delivery',
          'Kid-friendly options',
          'Flexible delivery schedule',
          'No commitment - cancel anytime'
        ],
      },
      {
        'id': 'plan_3',
        'name': 'Premium Plan',
        'description': 'Our premium plan features gourmet meals prepared by top chefs. Perfect for food enthusiasts who appreciate high-quality dining at home.',
        'price': 69.99,
        'delivery_frequency': 'Weekly',
        'billing_frequency': 'week',
        'plan_duration': 'Monthly',
        'meal_count': 7,
        'serving_size': 2,
        'is_popular': true,
        'features': [
          '7 premium meals per week',
          'Gourmet ingredients',
          'Chef-inspired recipes',
          'Free delivery',
          'Priority customer support',
          'No commitment - cancel anytime'
        ],
      },
      {
        'id': 'plan_4',
        'name': 'Vegetarian Plan',
        'description': 'A plant-based meal plan with diverse, flavorful vegetarian options. Enjoy healthy, sustainable meals delivered to your door.',
        'price': 59.99,
        'delivery_frequency': 'Weekly',
        'billing_frequency': 'week',
        'plan_duration': 'Monthly',
        'meal_count': 7,
        'serving_size': 1,
        'is_popular': false,
        'features': [
          '7 vegetarian meals per week',
          'Plant-based proteins',
          'Locally sourced vegetables',
          'Free delivery',
          'No commitment - cancel anytime'
        ],
      },
      {
        'id': 'plan_5',
        'name': 'Annual Basic Plan',
        'description': 'Our annual basic plan offers all the benefits of the regular basic plan with significant savings when you commit to a full year.',
        'price': 39.99,
        'delivery_frequency': 'Weekly',
        'billing_frequency': 'week',
        'plan_duration': 'Annual',
        'meal_count': 5,
        'serving_size': 1,
        'is_popular': false,
        'features': [
          '5 meals per week',
          'Free delivery',
          '20% savings compared to monthly plan',
          'Weekly menu rotation',
          'Annual commitment'
        ],
      },
      {
        'id': 'plan_6',
        'name': 'Annual Family Plan',
        'description': 'Save big with our annual family plan subscription. Enjoy a year of convenient, delicious meals for the whole family at a discounted rate.',
        'price': 71.99,
        'delivery_frequency': 'Weekly',
        'billing_frequency': 'week',
        'plan_duration': 'Annual',
        'meal_count': 10,
        'serving_size': 4,
        'is_popular': false,
        'features': [
          '10 family-size meals per week',
          'Free delivery',
          '20% savings compared to monthly plan',
          'Kid-friendly options',
          'Flexible delivery schedule',
          'Annual commitment'
        ],
      },
    ];

    return {
      'success': true,
      'meal_plans': plans,
    };
  }

  // Mock fetch user subscription
  Future<Map<String, dynamic>> fetchUserSubscription({
    required String userId,
    required String token,
  }) async {
    // Validate token
    if (_tokens[userId] != token) {
      return {
        'success': false,
        'message': 'Unauthorized',
      };
    }

    // Check if the user exists
    if (!_users.containsKey(userId)) {
      return {
        'success': false,
        'message': 'User not found',
      };
    }

    return {
      'success': true,
      'subscription': _userSubscriptions[userId]?.toJson(),
    };
  }

  // Mock create subscription
  Future<Map<String, dynamic>> createSubscription({
    required String planId,
    required String userId,
    required String token,
    required String deliveryDay,
    required String paymentMethod,
  }) async {
    // Validate token
    if (_tokens[userId] != token) {
      return {
        'success': false,
        'message': 'Unauthorized',
      };
    }

    // Check if the user exists
    if (!_users.containsKey(userId)) {
      return {
        'success': false,
        'message': 'User not found',
      };
    }

    // Check if the user already has an active subscription
    if (_userSubscriptions[userId] != null) {
      return {
        'success': false,
        'message': 'User already has an active subscription',
      };
    }

    // Get the plan details
    final plansResponse = await fetchMealPlans();
    if (!plansResponse['success']) {
      return plansResponse;
    }

    final plans = plansResponse['meal_plans'] as List;
    final plan = plans.firstWhere(
      (p) => p['id'] == planId,
      orElse: () => null,
    );

    if (plan == null) {
      return {
        'success': false,
        'message': 'Plan not found',
      };
    }

    // Create a new subscription
    final subscriptionId = _generateId();
    final now = DateTime.now();
    final nextBillingDate = now.add(const Duration(days: 30));
    
    final subscription = Subscription(
      id: subscriptionId,
      userId: userId,
      planId: planId,
      startDate: now,
      nextBillingDate: nextBillingDate,
      status: 'active',
      price: plan['price'],
      paymentMethod: paymentMethod,
    );

    _userSubscriptions[userId] = subscription;

    return {
      'success': true,
      'subscription': subscription.toJson(),
    };
  }

  // Mock cancel subscription
  Future<Map<String, dynamic>> cancelSubscription({
    required String subscriptionId,
    required String userId,
    required String token,
  }) async {
    // Validate token
    if (_tokens[userId] != token) {
      return {
        'success': false,
        'message': 'Unauthorized',
      };
    }

    // Check if the user exists
    if (!_users.containsKey(userId)) {
      return {
        'success': false,
        'message': 'User not found',
      };
    }

    // Check if the user has an active subscription
    if (_userSubscriptions[userId] == null) {
      return {
        'success': false,
        'message': 'User does not have an active subscription',
      };
    }

    // Check if the subscription ID matches
    if (_userSubscriptions[userId]!.id != subscriptionId) {
      return {
        'success': false,
        'message': 'Subscription ID does not match',
      };
    }

    // Cancel the subscription
    _userSubscriptions[userId] = null;

    return {
      'success': true,
      'message': 'Subscription cancelled successfully',
    };
  }

  // Mock update subscription
  Future<Map<String, dynamic>> updateSubscription({
    required String subscriptionId,
    required String newPlanId,
    required String userId,
    required String token,
    required String deliveryDay,
    required String paymentMethod,
  }) async {
    // Validate token
    if (_tokens[userId] != token) {
      return {
        'success': false,
        'message': 'Unauthorized',
      };
    }

    // Check if the user exists
    if (!_users.containsKey(userId)) {
      return {
        'success': false,
        'message': 'User not found',
      };
    }

    // Check if the user has an active subscription
    if (_userSubscriptions[userId] == null) {
      return {
        'success': false,
        'message': 'User does not have an active subscription',
      };
    }

    // Check if the subscription ID matches
    if (_userSubscriptions[userId]!.id != subscriptionId) {
      return {
        'success': false,
        'message': 'Subscription ID does not match',
      };
    }

    // Get the plan details
    final plansResponse = await fetchMealPlans();
    if (!plansResponse['success']) {
      return plansResponse;
    }

    final plans = plansResponse['meal_plans'] as List;
    final plan = plans.firstWhere(
      (p) => p['id'] == newPlanId,
      orElse: () => null,
    );

    if (plan == null) {
      return {
        'success': false,
        'message': 'Plan not found',
      };
    }

    // Update the subscription
    final now = DateTime.now();
    final nextBillingDate = now.add(const Duration(days: 30));
    
    final updatedSubscription = _userSubscriptions[userId]!.copyWith(
      planId: newPlanId,
      startDate: now,
      nextBillingDate: nextBillingDate,
      price: plan['price'],
      paymentMethod: paymentMethod,
    );

    _userSubscriptions[userId] = updatedSubscription;

    return {
      'success': true,
      'subscription': updatedSubscription.toJson(),
    };
  }

  // Mock fetch user orders
  Future<Map<String, dynamic>> fetchUserOrders({
    required String userId,
    required String token,
  }) async {
    // Validate token
    if (_tokens[userId] != token) {
      return {
        'success': false,
        'message': 'Unauthorized',
      };
    }

    // Check if the user exists
    if (!_users.containsKey(userId)) {
      return {
        'success': false,
        'message': 'User not found',
      };
    }

    // If there are no orders yet, generate some mock orders
    if (_userOrders[userId]!.isEmpty) {
      await _generateMockOrders(userId);
    }

    return {
      'success': true,
      'orders': _userOrders[userId]!.map((order) => order.toJson()).toList(),
    };
  }

  // Helper method to generate mock orders
  Future<void> _generateMockOrders(String userId) async {
    // Fetch meals for order items
    final mealsResponse = await fetchMeals();
    if (!mealsResponse['success']) {
      return;
    }

    final mealsList = mealsResponse['meals'] as List;
    final List<Order> orders = [];

    // Generate a few orders with different statuses
    final statuses = ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];
    final paymentMethods = ['Credit Card', 'PayPal', 'Apple Pay', 'Google Pay'];

    for (int i = 0; i < 5; i++) {
      final int itemCount = 1 + _random.nextInt(4);
      final List<OrderItem> items = [];
      double subtotal = 0;

      // Add random meals to the order
      for (int j = 0; j < itemCount; j++) {
        final mealJson = mealsList[_random.nextInt(mealsList.length)];
        final meal = Meal.fromJson(mealJson);
        final quantity = 1 + _random.nextInt(3);
        final price = meal.displayPrice;
        subtotal += price * quantity;

        items.add(OrderItem(
          meal: meal,
          quantity: quantity,
          price: price,
        ));
      }

      final double tax = subtotal * 0.08; // 8% tax
      final double deliveryFee = subtotal >= 50 ? 0.0 : 6.99;
      final double total = subtotal + tax + deliveryFee;

      // Generate dates
      final now = DateTime.now();
      final orderDate = now.subtract(Duration(days: _random.nextInt(90)));
      final deliveryDate = orderDate.add(Duration(days: 1 + _random.nextInt(5)));
      
      // Generate delivery time
      final deliveryHour = 8 + _random.nextInt(12); // Between 8 AM and 8 PM
      final deliveryTime = '${deliveryHour % 12 == 0 ? 12 : deliveryHour % 12}:00 ${deliveryHour < 12 ? 'AM' : 'PM'} - ${(deliveryHour + 1) % 12 == 0 ? 12 : (deliveryHour + 1) % 12}:00 ${(deliveryHour + 1) < 12 ? 'AM' : 'PM'}';

      // Generate order status (make sure older orders are more likely to be delivered)
      final daysSinceOrder = now.difference(orderDate).inDays;
      String status;
      if (daysSinceOrder > 7) {
        // Older orders are likely delivered or cancelled
        status = _random.nextInt(10) > 1 ? 'Delivered' : 'Cancelled';
      } else if (daysSinceOrder > 3) {
        // Orders a few days old are likely shipped or delivered
        status = statuses[2 + _random.nextInt(2)];
      } else {
        // Recent orders are pending or processing
        status = statuses[_random.nextInt(2)];
      }

      // Create the order
      final order = Order(
        id: 'order_${userId}_${i + 1}',
        userId: userId,
        items: items,
        subtotal: subtotal,
        tax: tax,
        deliveryFee: deliveryFee,
        total: total,
        orderDate: orderDate,
        deliveryDate: deliveryDate,
        deliveryTime: deliveryTime,
        deliveryAddress: _users[userId]!.address ?? '123 Main St, Anytown, US 12345',
        status: status,
        paymentMethod: paymentMethods[_random.nextInt(paymentMethods.length)],
        trackingNumber: status == 'Shipped' || status == 'Delivered' ? 'TRK${100000 + _random.nextInt(900000)}' : null,
      );

      orders.add(order);
    }

    // Sort by order date (newest first)
    orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    _userOrders[userId] = orders;
  }

  // Mock place order
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
    // Validate token
    if (_tokens[userId] != token) {
      return {
        'success': false,
        'message': 'Unauthorized',
      };
    }

    // Check if the user exists
    if (!_users.containsKey(userId)) {
      return {
        'success': false,
        'message': 'User not found',
      };
    }

    // Create a new order
    final orderId = 'order_${userId}_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    
    final order = Order(
      id: orderId,
      userId: userId,
      items: items,
      subtotal: subtotal,
      tax: tax,
      deliveryFee: deliveryFee,
      total: total,
      orderDate: now,
      deliveryDate: deliveryDate,
      deliveryTime: deliveryTime,
      deliveryAddress: deliveryAddress,
      status: 'Pending',
      paymentMethod: 'Credit Card',
    );

    _userOrders[userId]!.insert(0, order);

    return {
      'success': true,
      'order': order.toJson(),
    };
  }

  // Mock cancel order
  Future<Map<String, dynamic>> cancelOrder({
    required String orderId,
    required String userId,
    required String token,
  }) async {
    // Validate token
    if (_tokens[userId] != token) {
      return {
        'success': false,
        'message': 'Unauthorized',
      };
    }

    // Check if the user exists
    if (!_users.containsKey(userId)) {
      return {
        'success': false,
        'message': 'User not found',
      };
    }

    // Find the order
    final orderIndex = _userOrders[userId]!.indexWhere((order) => order.id == orderId);
    if (orderIndex == -1) {
      return {
        'success': false,
        'message': 'Order not found',
      };
    }

    // Check if the order can be cancelled
    final order = _userOrders[userId]![orderIndex];
    if (order.status == 'Delivered' || order.status == 'Cancelled') {
      return {
        'success': false,
        'message': 'Order cannot be cancelled because it is already ${order.status.toLowerCase()}',
      };
    }

    // Cancel the order
    final updatedOrder = order.copyWith(status: 'Cancelled');
    _userOrders[userId]![orderIndex] = updatedOrder;

    return {
      'success': true,
      'order': updatedOrder.toJson(),
    };
  }
}
