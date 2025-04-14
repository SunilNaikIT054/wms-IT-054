class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? avatar;
  final List<Address> addresses;
  final PaymentMethod? defaultPaymentMethod;
  final List<PaymentMethod> paymentMethods;
  final DateTime createdAt;
  final bool isEmailVerified;
  
  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.avatar,
    this.addresses = const [],
    this.defaultPaymentMethod,
    this.paymentMethods = const [],
    required this.createdAt,
    this.isEmailVerified = false,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    List<Address> addresses = [];
    if (json['addresses'] != null) {
      addresses = (json['addresses'] as List)
          .map((address) => Address.fromJson(address))
          .toList();
    }
    
    List<PaymentMethod> paymentMethods = [];
    if (json['paymentMethods'] != null) {
      paymentMethods = (json['paymentMethods'] as List)
          .map((method) => PaymentMethod.fromJson(method))
          .toList();
    }
    
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      avatar: json['avatar'],
      addresses: addresses,
      defaultPaymentMethod: json['defaultPaymentMethod'] != null
          ? PaymentMethod.fromJson(json['defaultPaymentMethod'])
          : null,
      paymentMethods: paymentMethods,
      createdAt: DateTime.parse(json['createdAt']),
      isEmailVerified: json['isEmailVerified'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'avatar': avatar,
      'addresses': addresses.map((address) => address.toJson()).toList(),
      'defaultPaymentMethod': defaultPaymentMethod?.toJson(),
      'paymentMethods': paymentMethods.map((method) => method.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'isEmailVerified': isEmailVerified,
    };
  }
  
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? avatar,
    List<Address>? addresses,
    PaymentMethod? defaultPaymentMethod,
    List<PaymentMethod>? paymentMethods,
    DateTime? createdAt,
    bool? isEmailVerified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      addresses: addresses ?? this.addresses,
      defaultPaymentMethod: defaultPaymentMethod ?? this.defaultPaymentMethod,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      createdAt: createdAt ?? this.createdAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}

class Address {
  final String id;
  final String label;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;
  
  Address({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });
  
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      label: json['label'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
      isDefault: json['isDefault'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'isDefault': isDefault,
    };
  }
  
  String get fullAddress {
    return '$street, $city, $state $zipCode, $country';
  }
  
  Address copyWith({
    String? id,
    String? label,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class PaymentMethod {
  final String id;
  final String type; // 'credit_card', 'paypal', etc.
  final String? cardholderName;
  final String? lastFourDigits;
  final String? cardType; // 'visa', 'mastercard', etc.
  final String? expiryDate;
  final bool isDefault;
  
  PaymentMethod({
    required this.id,
    required this.type,
    this.cardholderName,
    this.lastFourDigits,
    this.cardType,
    this.expiryDate,
    this.isDefault = false,
  });
  
  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      type: json['type'],
      cardholderName: json['cardholderName'],
      lastFourDigits: json['lastFourDigits'],
      cardType: json['cardType'],
      expiryDate: json['expiryDate'],
      isDefault: json['isDefault'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'cardholderName': cardholderName,
      'lastFourDigits': lastFourDigits,
      'cardType': cardType,
      'expiryDate': expiryDate,
      'isDefault': isDefault,
    };
  }
  
  String get displayName {
    if (type == 'credit_card' && lastFourDigits != null) {
      String cardTypeName = cardType?.toUpperCase() ?? 'Card';
      return '$cardTypeName ending in $lastFourDigits';
    } else if (type == 'paypal') {
      return 'PayPal';
    } else {
      return 'Payment Method';
    }
  }
  
  PaymentMethod copyWith({
    String? id,
    String? type,
    String? cardholderName,
    String? lastFourDigits,
    String? cardType,
    String? expiryDate,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      cardholderName: cardholderName ?? this.cardholderName,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      cardType: cardType ?? this.cardType,
      expiryDate: expiryDate ?? this.expiryDate,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
