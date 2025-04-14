import 'package:flutter/foundation.dart';

class Meal {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discount;
  final String imageUrl;
  final int calories;
  final int preparationTime; // in minutes
  final List<String> ingredients;
  final List<String> nutritionFacts;
  final double rating;
  final int reviewCount;
  final List<String> allergens;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final String category;
  final bool isAvailable;
  final List<String> tags;
  
  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discount,
    required this.imageUrl,
    required this.calories,
    required this.preparationTime,
    required this.ingredients,
    required this.nutritionFacts,
    required this.rating,
    required this.reviewCount,
    required this.allergens,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isGlutenFree = false,
    required this.category,
    this.isAvailable = true,
    this.tags = const [],
  });
  
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      discount: json['discount']?.toDouble(),
      imageUrl: json['imageUrl'],
      calories: json['calories'],
      preparationTime: json['preparationTime'],
      ingredients: List<String>.from(json['ingredients']),
      nutritionFacts: List<String>.from(json['nutritionFacts']),
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      allergens: List<String>.from(json['allergens']),
      isVegetarian: json['isVegetarian'] ?? false,
      isVegan: json['isVegan'] ?? false,
      isGlutenFree: json['isGlutenFree'] ?? false,
      category: json['category'],
      isAvailable: json['isAvailable'] ?? true,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount': discount,
      'imageUrl': imageUrl,
      'calories': calories,
      'preparationTime': preparationTime,
      'ingredients': ingredients,
      'nutritionFacts': nutritionFacts,
      'rating': rating,
      'reviewCount': reviewCount,
      'allergens': allergens,
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
      'isGlutenFree': isGlutenFree,
      'category': category,
      'isAvailable': isAvailable,
      'tags': tags,
    };
  }
  
  bool get hasDiscount => discount != null && discount! > 0;
  
  double get displayPrice {
    if (hasDiscount) {
      return price - (price * discount! / 100);
    }
    return price;
  }
  
  Meal copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? discount,
    String? imageUrl,
    int? calories,
    int? preparationTime,
    List<String>? ingredients,
    List<String>? nutritionFacts,
    double? rating,
    int? reviewCount,
    List<String>? allergens,
    bool? isVegetarian,
    bool? isVegan,
    bool? isGlutenFree,
    String? category,
    bool? isAvailable,
    List<String>? tags,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      imageUrl: imageUrl ?? this.imageUrl,
      calories: calories ?? this.calories,
      preparationTime: preparationTime ?? this.preparationTime,
      ingredients: ingredients ?? this.ingredients,
      nutritionFacts: nutritionFacts ?? this.nutritionFacts,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      allergens: allergens ?? this.allergens,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      tags: tags ?? this.tags,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Meal && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}

class CartItem {
  final Meal meal;
  final int quantity;
  final String? specialInstructions;
  
  CartItem({
    required this.meal,
    this.quantity = 1,
    this.specialInstructions,
  });
  
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      meal: Meal.fromJson(json['meal']),
      quantity: json['quantity'],
      specialInstructions: json['specialInstructions'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'meal': meal.toJson(),
      'quantity': quantity,
      'specialInstructions': specialInstructions,
    };
  }
  
  double get totalPrice => meal.displayPrice * quantity;
  
  CartItem copyWith({
    Meal? meal,
    int? quantity,
    String? specialInstructions,
  }) {
    return CartItem(
      meal: meal ?? this.meal,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is CartItem && other.meal.id == meal.id;
  }
  
  @override
  int get hashCode => meal.id.hashCode;
}
