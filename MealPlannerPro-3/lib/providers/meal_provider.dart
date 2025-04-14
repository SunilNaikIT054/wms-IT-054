import 'package:flutter/foundation.dart';
import '../models/meal.dart';
import '../services/api_service.dart';

class MealProvider with ChangeNotifier {
  List<Meal> _meals = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _searchQuery;
  String? _categoryFilter;
  Map<String, bool> _dietaryFilters = {
    'vegetarian': false,
    'vegan': false,
    'gluten_free': false,
  };
  String _sortOption = 'popular';

  MealProvider() {
    fetchMeals();
  }

  List<Meal> get meals => _filteredAndSortedMeals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get searchQuery => _searchQuery;
  String? get categoryFilter => _categoryFilter;
  Map<String, bool> get dietaryFilters => _dietaryFilters;
  String get sortOption => _sortOption;

  List<String> get categories {
    final categorySet = <String>{};
    for (final meal in _meals) {
      categorySet.add(meal.category);
    }
    return categorySet.toList()..sort();
  }

  List<Meal> get featuredMeals {
    return _meals.where((meal) => meal.rating >= 4.5).take(5).toList();
  }

  List<Meal> get popularMeals {
    final sortedMeals = List<Meal>.from(_meals);
    sortedMeals.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    return sortedMeals.take(10).toList();
  }

  List<Meal> getMealsByCategory(String category) {
    return _meals.where((meal) => meal.category == category).toList();
  }

  Meal? getMealById(String id) {
    try {
      return _meals.firstWhere((meal) => meal.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Meal> get _filteredAndSortedMeals {
    List<Meal> filteredMeals = List<Meal>.from(_meals);

    // Apply search query filter
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      final query = _searchQuery!.toLowerCase();
      filteredMeals = filteredMeals.where((meal) {
        return meal.name.toLowerCase().contains(query) ||
            meal.description.toLowerCase().contains(query) ||
            meal.category.toLowerCase().contains(query) ||
            meal.ingredients.any((ingredient) => ingredient.toLowerCase().contains(query));
      }).toList();
    }

    // Apply category filter
    if (_categoryFilter != null && _categoryFilter!.isNotEmpty) {
      filteredMeals = filteredMeals.where((meal) => meal.category == _categoryFilter).toList();
    }

    // Apply dietary filters
    if (_dietaryFilters['vegetarian'] == true) {
      filteredMeals = filteredMeals.where((meal) => meal.isVegetarian).toList();
    }
    if (_dietaryFilters['vegan'] == true) {
      filteredMeals = filteredMeals.where((meal) => meal.isVegan).toList();
    }
    if (_dietaryFilters['gluten_free'] == true) {
      filteredMeals = filteredMeals.where((meal) => meal.isGlutenFree).toList();
    }

    // Apply sorting
    switch (_sortOption) {
      case 'price_low':
        filteredMeals.sort((a, b) => a.displayPrice.compareTo(b.displayPrice));
        break;
      case 'price_high':
        filteredMeals.sort((a, b) => b.displayPrice.compareTo(a.displayPrice));
        break;
      case 'rating':
        filteredMeals.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'popular':
        filteredMeals.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case 'calories_low':
        filteredMeals.sort((a, b) => a.calories.compareTo(b.calories));
        break;
      case 'calories_high':
        filteredMeals.sort((a, b) => b.calories.compareTo(a.calories));
        break;
    }

    return filteredMeals;
  }

  Future<void> fetchMeals() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final apiService = ApiService();
      final response = await apiService.fetchMeals();

      if (response['success']) {
        _meals = (response['meals'] as List)
            .map((mealJson) => Meal.fromJson(mealJson))
            .toList();
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        _errorMessage = response['message'] ?? 'Failed to fetch meals';
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch meals: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
    }
  }

  Future<Meal?> fetchMealDetails(String mealId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // First check if we already have this meal in our list
      Meal? meal = getMealById(mealId);
      if (meal != null) {
        _isLoading = false;
        notifyListeners();
        return meal;
      }

      // If not, fetch it from the API
      final apiService = ApiService();
      final response = await apiService.fetchMealDetails(mealId);

      if (response['success']) {
        meal = Meal.fromJson(response['meal']);
        
        // Add this meal to our list if it's not already there
        if (getMealById(mealId) == null) {
          _meals.add(meal);
        }
        
        _isLoading = false;
        notifyListeners();
        return meal;
      } else {
        _isLoading = false;
        _errorMessage = response['message'] ?? 'Failed to fetch meal details';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to fetch meal details: ${e.toString()}';
      notifyListeners();
      print(_errorMessage);
      return null;
    }
  }

  void setSearchQuery(String? query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String? category) {
    _categoryFilter = category;
    notifyListeners();
  }

  void toggleDietaryFilter(String filter) {
    if (_dietaryFilters.containsKey(filter)) {
      _dietaryFilters[filter] = !_dietaryFilters[filter]!;
      notifyListeners();
    }
  }

  void setSortOption(String option) {
    _sortOption = option;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = null;
    _categoryFilter = null;
    _dietaryFilters = {
      'vegetarian': false,
      'vegan': false,
      'gluten_free': false,
    };
    _sortOption = 'popular';
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
