import 'package:flutter/foundation.dart';
import '../models/meal.dart';
import '../models/order.dart';
import '../services/storage_service.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  final double _taxRate = 0.08; // 8% tax
  final double _deliveryFeeThreshold = 50.0; // Free delivery for orders over $50
  final double _standardDeliveryFee = 6.99;

  CartProvider() {
    _loadCartFromStorage();
  }

  List<CartItem> get items => _items;
  bool get isEmpty => _items.isEmpty;
  int get totalItemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(
        0,
        (sum, item) => sum + item.totalPrice,
      );

  double get taxAmount => totalPrice * _taxRate;

  double get deliveryFee =>
      totalPrice >= _deliveryFeeThreshold ? 0.0 : _standardDeliveryFee;

  double get grandTotal => totalPrice + taxAmount + deliveryFee;

  Future<void> _loadCartFromStorage() async {
    try {
      final storageService = StorageService();
      final cartData = await storageService.getCart();

      if (cartData != null) {
        _items = (cartData as List)
            .map((itemJson) => CartItem.fromJson(itemJson))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      print('Failed to load cart from storage: $e');
    }
  }

  Future<void> _saveCartToStorage() async {
    try {
      final storageService = StorageService();
      await storageService.saveCart(
        _items.map((item) => item.toJson()).toList(),
      );
    } catch (e) {
      print('Failed to save cart to storage: $e');
    }
  }

  void addToCart(Meal meal, {int quantity = 1}) {
    // Check if the meal is already in the cart
    final existingIndex = _items.indexWhere((item) => item.meal.id == meal.id);

    if (existingIndex >= 0) {
      // If the meal is already in the cart, increment the quantity
      _items[existingIndex].quantity += quantity;
    } else {
      // Otherwise, add the meal as a new item
      _items.add(CartItem(meal: meal, quantity: quantity));
    }

    _saveCartToStorage();
    notifyListeners();
  }

  void removeFromCart(String mealId) {
    _items.removeWhere((item) => item.meal.id == mealId);
    _saveCartToStorage();
    notifyListeners();
  }

  void incrementQuantity(String mealId) {
    final index = _items.indexWhere((item) => item.meal.id == mealId);
    if (index >= 0) {
      _items[index].quantity++;
      _saveCartToStorage();
      notifyListeners();
    }
  }

  void decrementQuantity(String mealId) {
    final index = _items.indexWhere((item) => item.meal.id == mealId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      _saveCartToStorage();
      notifyListeners();
    }
  }

  void updateQuantity(String mealId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(mealId);
      return;
    }

    final index = _items.indexWhere((item) => item.meal.id == mealId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      _saveCartToStorage();
      notifyListeners();
    }
  }

  void clearCart() {
    _items = [];
    _saveCartToStorage();
    notifyListeners();
  }

  bool isMealInCart(String mealId) {
    return _items.any((item) => item.meal.id == mealId);
  }

  int getQuantity(String mealId) {
    final item = _items.firstWhere(
      (item) => item.meal.id == mealId,
      orElse: () => CartItem(meal: Meal(
        id: '',
        name: '',
        description: '',
        price: 0,
        imageUrl: '',
        ingredients: [],
        allergens: [],
        category: '',
        nutritionalInfo: {},
        preparationTime: 0,
        isSpicy: false,
        isVegetarian: false,
        isVegan: false,
        isGlutenFree: false,
        calories: 0,
        rating: 0,
        reviewCount: 0,
      ), quantity: 0),
    );
    return item.quantity;
  }
}
