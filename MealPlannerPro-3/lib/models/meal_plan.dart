class MealPlan {
  final String id;
  final String name;
  final String description;
  final double price;
  final int mealCount;
  final int servingSize;
  final String planDuration; // "Monthly", "Yearly"
  final String billingFrequency; // "week", "month", "year"
  final String deliveryFrequency; // "Weekly", "Bi-Weekly", "Monthly"
  final List<String> features;
  final bool isPopular;
  final String imageUrl;
  
  MealPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.mealCount,
    required this.servingSize,
    required this.planDuration,
    required this.billingFrequency,
    required this.deliveryFrequency,
    required this.features,
    this.isPopular = false,
    required this.imageUrl,
  });
  
  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      mealCount: json['mealCount'],
      servingSize: json['servingSize'],
      planDuration: json['planDuration'],
      billingFrequency: json['billingFrequency'],
      deliveryFrequency: json['deliveryFrequency'],
      features: List<String>.from(json['features']),
      isPopular: json['isPopular'] ?? false,
      imageUrl: json['imageUrl'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'mealCount': mealCount,
      'servingSize': servingSize,
      'planDuration': planDuration,
      'billingFrequency': billingFrequency,
      'deliveryFrequency': deliveryFrequency,
      'features': features,
      'isPopular': isPopular,
      'imageUrl': imageUrl,
    };
  }
  
  // Calculate per-meal price
  double get pricePerMeal {
    return price / mealCount;
  }
  
  MealPlan copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? mealCount,
    int? servingSize,
    String? planDuration,
    String? billingFrequency,
    String? deliveryFrequency,
    List<String>? features,
    bool? isPopular,
    String? imageUrl,
  }) {
    return MealPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      mealCount: mealCount ?? this.mealCount,
      servingSize: servingSize ?? this.servingSize,
      planDuration: planDuration ?? this.planDuration,
      billingFrequency: billingFrequency ?? this.billingFrequency,
      deliveryFrequency: deliveryFrequency ?? this.deliveryFrequency,
      features: features ?? this.features,
      isPopular: isPopular ?? this.isPopular,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is MealPlan && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}
