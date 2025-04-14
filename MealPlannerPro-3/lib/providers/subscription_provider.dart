import 'package:flutter/foundation.dart';
import '../models/meal_plan.dart';
import '../models/subscription.dart';
import '../services/api_service.dart';

class SubscriptionProvider with ChangeNotifier {
  List<MealPlan> _mealPlans = [];
  Subscription? _activeSubscription;
  bool _isLoading = false;
  String? _errorMessage;

  SubscriptionProvider() {
    fetchMealPlans();
  }

  List<MealPlan> get mealPlans => _mealPlans;
  Subscription? get activeSubscription => _activeSubscription;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasActiveSubscription => _activeSubscription != null && _activeSubscription!.isActive;

  Future<void> fetchMealPlans() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final apiService = ApiService();
      final response = await apiService.fetchMealPlans();

      if (response['success']) {
        _mealPlans = (response['meal_plans'] as List)
            .map((planJson) => MealPlan.fromJson(planJson))
            .toList();
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        _errorMessage = response['message'] ?? 'Failed to fetch meal plans';
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch meal plans: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
    }
  }

  Future<void> fetchUserSubscription({required String userId, required String token}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final apiService = ApiService();
      final response = await apiService.fetchUserSubscription(userId: userId, token: token);

      _isLoading = false;

      if (response['success']) {
        if (response['subscription'] != null) {
          _activeSubscription = Subscription.fromJson(response['subscription']);
        } else {
          _activeSubscription = null;
        }
        notifyListeners();
      } else {
        _errorMessage = response['message'] ?? 'Failed to fetch subscription';
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch subscription: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
    }
  }

  Future<bool> createSubscription({
    required String planId,
    required String userId,
    required String token,
    required String deliveryDay,
    required String paymentMethod,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final apiService = ApiService();
      final response = await apiService.createSubscription(
        planId: planId,
        userId: userId,
        token: token,
        deliveryDay: deliveryDay,
        paymentMethod: paymentMethod,
      );

      _isLoading = false;

      if (response['success']) {
        _activeSubscription = Subscription.fromJson(response['subscription']);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to create subscription';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to create subscription: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
      return false;
    }
  }

  Future<bool> cancelSubscription({
    required String userId,
    required String token,
  }) async {
    try {
      if (_activeSubscription == null) {
        _errorMessage = 'No active subscription found';
        notifyListeners();
        return false;
      }

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final apiService = ApiService();
      final response = await apiService.cancelSubscription(
        subscriptionId: _activeSubscription!.id,
        userId: userId,
        token: token,
      );

      _isLoading = false;

      if (response['success']) {
        _activeSubscription = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to cancel subscription';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to cancel subscription: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
      return false;
    }
  }

  Future<bool> updateSubscription({
    required String newPlanId,
    required String userId,
    required String token,
    required String deliveryDay,
    required String paymentMethod,
  }) async {
    try {
      if (_activeSubscription == null) {
        _errorMessage = 'No active subscription found';
        notifyListeners();
        return false;
      }

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final apiService = ApiService();
      final response = await apiService.updateSubscription(
        subscriptionId: _activeSubscription!.id,
        newPlanId: newPlanId,
        userId: userId,
        token: token,
        deliveryDay: deliveryDay,
        paymentMethod: paymentMethod,
      );

      _isLoading = false;

      if (response['success']) {
        _activeSubscription = Subscription.fromJson(response['subscription']);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to update subscription';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to update subscription: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
      return false;
    }
  }

  MealPlan? getMealPlanById(String planId) {
    try {
      return _mealPlans.firstWhere((plan) => plan.id == planId);
    } catch (e) {
      return null;
    }
  }

  MealPlan? getActiveSubscriptionPlan() {
    if (_activeSubscription != null) {
      return getMealPlanById(_activeSubscription!.planId);
    }
    return null;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
