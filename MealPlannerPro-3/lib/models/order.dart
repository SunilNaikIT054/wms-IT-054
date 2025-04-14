import 'meal.dart';

class OrderItem {
  final Meal meal;
  final int quantity;
  final double price;

  OrderItem({
    required this.meal,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      meal: Meal.fromJson(json['meal']),
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meal': meal.toJson(),
      'quantity': quantity,
      'price': price,
    };
  }

  double get totalPrice => price * quantity;
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final String deliveryTime;
  final String deliveryAddress;
  final String status;
  final String paymentMethod;
  final String? trackingNumber;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
    required this.orderDate,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.deliveryAddress,
    required this.status,
    required this.paymentMethod,
    this.trackingNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      tax: json['tax'].toDouble(),
      deliveryFee: json['delivery_fee'].toDouble(),
      total: json['total'].toDouble(),
      orderDate: DateTime.parse(json['order_date']),
      deliveryDate: DateTime.parse(json['delivery_date']),
      deliveryTime: json['delivery_time'],
      deliveryAddress: json['delivery_address'],
      status: json['status'],
      paymentMethod: json['payment_method'],
      trackingNumber: json['tracking_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'delivery_fee': deliveryFee,
      'total': total,
      'order_date': orderDate.toIso8601String(),
      'delivery_date': deliveryDate.toIso8601String(),
      'delivery_time': deliveryTime,
      'delivery_address': deliveryAddress,
      'status': status,
      'payment_method': paymentMethod,
      if (trackingNumber != null) 'tracking_number': trackingNumber,
    };
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isDelivered => status == 'Delivered';

  bool get isCancelled => status == 'Cancelled';

  Order copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    double? subtotal,
    double? tax,
    double? deliveryFee,
    double? total,
    DateTime? orderDate,
    DateTime? deliveryDate,
    String? deliveryTime,
    String? deliveryAddress,
    String? status,
    String? paymentMethod,
    String? trackingNumber,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      trackingNumber: trackingNumber ?? this.trackingNumber,
    );
  }
}

class CartItem {
  final Meal meal;
  int quantity;

  CartItem({
    required this.meal,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      meal: Meal.fromJson(json['meal']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meal': meal.toJson(),
      'quantity': quantity,
    };
  }

  double get totalPrice => meal.displayPrice * quantity;

  CartItem copyWith({
    Meal? meal,
    int? quantity,
  }) {
    return CartItem(
      meal: meal ?? this.meal,
      quantity: quantity ?? this.quantity,
    );
  }
}
