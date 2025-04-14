import 'meal_plan.dart';

class Subscription {
  final String id;
  final String userId;
  final String planId;
  final DateTime startDate;
  final DateTime nextBillingDate;
  final DateTime? endDate;
  final String status; // 'active', 'paused', 'cancelled'
  final double price;
  final String billingFrequency; // 'monthly', 'yearly'
  final String paymentMethod;
  final List<DeliverySchedule> deliverySchedule;
  
  Subscription({
    required this.id,
    required this.userId,
    required this.planId,
    required this.startDate,
    required this.nextBillingDate,
    this.endDate,
    required this.status,
    required this.price,
    required this.billingFrequency,
    required this.paymentMethod,
    this.deliverySchedule = const [],
  });
  
  factory Subscription.fromJson(Map<String, dynamic> json) {
    List<DeliverySchedule> deliverySchedule = [];
    if (json['deliverySchedule'] != null) {
      deliverySchedule = (json['deliverySchedule'] as List)
          .map((schedule) => DeliverySchedule.fromJson(schedule))
          .toList();
    }
    
    return Subscription(
      id: json['id'],
      userId: json['userId'],
      planId: json['planId'],
      startDate: DateTime.parse(json['startDate']),
      nextBillingDate: DateTime.parse(json['nextBillingDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      status: json['status'],
      price: json['price'].toDouble(),
      billingFrequency: json['billingFrequency'],
      paymentMethod: json['paymentMethod'],
      deliverySchedule: deliverySchedule,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'planId': planId,
      'startDate': startDate.toIso8601String(),
      'nextBillingDate': nextBillingDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
      'price': price,
      'billingFrequency': billingFrequency,
      'paymentMethod': paymentMethod,
      'deliverySchedule': deliverySchedule.map((schedule) => schedule.toJson()).toList(),
    };
  }
  
  bool get isActive => status == 'active';
  bool get isPaused => status == 'paused';
  bool get isCancelled => status == 'cancelled';
  
  Subscription copyWith({
    String? id,
    String? userId,
    String? planId,
    DateTime? startDate,
    DateTime? nextBillingDate,
    DateTime? endDate,
    String? status,
    double? price,
    String? billingFrequency,
    String? paymentMethod,
    List<DeliverySchedule>? deliverySchedule,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      startDate: startDate ?? this.startDate,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      price: price ?? this.price,
      billingFrequency: billingFrequency ?? this.billingFrequency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliverySchedule: deliverySchedule ?? this.deliverySchedule,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Subscription && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}

class DeliverySchedule {
  final String id;
  final DateTime deliveryDate;
  final String status; // 'scheduled', 'delivered', 'missed'
  final DateTime? actualDeliveryDate;
  final String? trackingNumber;
  final String? notes;
  
  DeliverySchedule({
    required this.id,
    required this.deliveryDate,
    required this.status,
    this.actualDeliveryDate,
    this.trackingNumber,
    this.notes,
  });
  
  factory DeliverySchedule.fromJson(Map<String, dynamic> json) {
    return DeliverySchedule(
      id: json['id'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
      status: json['status'],
      actualDeliveryDate: json['actualDeliveryDate'] != null
          ? DateTime.parse(json['actualDeliveryDate'])
          : null,
      trackingNumber: json['trackingNumber'],
      notes: json['notes'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deliveryDate': deliveryDate.toIso8601String(),
      'status': status,
      'actualDeliveryDate': actualDeliveryDate?.toIso8601String(),
      'trackingNumber': trackingNumber,
      'notes': notes,
    };
  }
  
  DeliverySchedule copyWith({
    String? id,
    DateTime? deliveryDate,
    String? status,
    DateTime? actualDeliveryDate,
    String? trackingNumber,
    String? notes,
  }) {
    return DeliverySchedule(
      id: id ?? this.id,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      status: status ?? this.status,
      actualDeliveryDate: actualDeliveryDate ?? this.actualDeliveryDate,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      notes: notes ?? this.notes,
    );
  }
}

class SubscriptionWithPlan {
  final Subscription subscription;
  final MealPlan plan;
  
  SubscriptionWithPlan({
    required this.subscription,
    required this.plan,
  });
  
  factory SubscriptionWithPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionWithPlan(
      subscription: Subscription.fromJson(json['subscription']),
      plan: MealPlan.fromJson(json['plan']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'subscription': subscription.toJson(),
      'plan': plan.toJson(),
    };
  }
}
