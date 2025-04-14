class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    
    // Check for password complexity (optional)
    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasDigits = value.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    if (!hasUppercase || !hasDigits || !hasSpecialCharacters) {
      return 'Password must contain uppercase, number, and special character';
    }
    
    return null;
  }
  
  // Name validation
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name is too short';
    }
    
    return null;
  }
  
  // Phone number validation
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Allow formats like (123) 456-7890, 123-456-7890, 1234567890
    final phoneRegExp = RegExp(
      r'^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$',
    );
    
    if (!phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }
  
  // Address validation
  static String? address(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    
    if (value.length < 5) {
      return 'Please enter a valid address';
    }
    
    return null;
  }
  
  // ZIP/Postal code validation
  static String? zipCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'ZIP code is required';
    }
    
    // US ZIP code (5 digits or 5+4 format)
    final zipRegExp = RegExp(r'^\d{5}(-\d{4})?$');
    
    if (!zipRegExp.hasMatch(value)) {
      return 'Please enter a valid ZIP code';
    }
    
    return null;
  }
  
  // Credit card number validation
  static String? creditCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required';
    }
    
    // Remove spaces and dashes
    final cleanValue = value.replaceAll(RegExp(r'\s+|-'), '');
    
    // Check if digits only
    if (!RegExp(r'^\d+$').hasMatch(cleanValue)) {
      return 'Card number can only contain digits';
    }
    
    // Check length (13-19 digits for most cards)
    if (cleanValue.length < 13 || cleanValue.length > 19) {
      return 'Invalid card number length';
    }
    
    // Luhn algorithm (checksum)
    int sum = 0;
    bool alternate = false;
    
    for (int i = cleanValue.length - 1; i >= 0; i--) {
      int digit = int.parse(cleanValue[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    if (sum % 10 != 0) {
      return 'Invalid card number';
    }
    
    return null;
  }
  
  // Credit card expiry validation
  static String? expiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    
    // Check format (MM/YY or MM/YYYY)
    if (!RegExp(r'^\d{2}\/\d{2}(\d{2})?$').hasMatch(value)) {
      return 'Use format MM/YY';
    }
    
    final parts = value.split('/');
    final month = int.tryParse(parts[0]);
    int? year = int.tryParse(parts[1]);
    
    // Validate month
    if (month == null || month < 1 || month > 12) {
      return 'Invalid month';
    }
    
    // Adjust year
    if (year != null && year < 100) {
      year += 2000;
    }
    
    // Check if expired
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;
    
    if (year! < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Card has expired';
    }
    
    return null;
  }
  
  // CVV validation
  static String? cvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }
    
    if (!RegExp(r'^\d{3,4}$').hasMatch(value)) {
      return 'CVV must be 3 or 4 digits';
    }
    
    return null;
  }
  
  // Required field validation
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    
    return null;
  }
  
  // Confirm password validation
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
}
