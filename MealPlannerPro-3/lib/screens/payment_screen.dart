import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../utils/validators.dart';
import '../utils/constants.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _zipCodeController = TextEditingController();
  
  String _selectedPaymentMethod = AppConstants.paymentMethods[0]; // Default to Credit Card
  String _selectedDeliveryTime = AppConstants.deliveryTimeSlots[0]; // Default to first time slot
  
  DateTime _deliveryDate = DateTime.now().add(const Duration(days: 1));
  
  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }
  
  void _initializeUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isLoggedIn && authProvider.user != null) {
      final user = authProvider.user!;
      _nameController.text = user.name;
      if (user.address != null) {
        _addressController.text = user.address!;
      }
    }
  }
  
  Future<void> _selectDeliveryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 14)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _deliveryDate) {
      setState(() {
        _deliveryDate = picked;
      });
    }
  }
  
  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    
    if (!authProvider.isLoggedIn) {
      _showLoginRequiredDialog();
      return;
    }
    
    if (cartProvider.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Show loading dialog
    _showLoadingDialog();
    
    // Process order
    final order = await orderProvider.placeOrder(
      userId: authProvider.user!.id,
      token: authProvider.token!,
      cart: cartProvider,
      deliveryAddress: _addressController.text,
      deliveryDate: _deliveryDate,
      deliveryTime: _selectedDeliveryTime,
    );
    
    // Close loading dialog
    Navigator.pop(context);
    
    if (order != null) {
      // Clear cart
      cartProvider.clearCart();
      
      // Show order confirmation
      _showOrderConfirmationDialog(order);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(orderProvider.errorMessage ?? 'Failed to place order'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('Please log in to complete your purchase'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to login screen
              // TODO: Implement navigation to login screen
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
  
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Processing your order...'),
          ],
        ),
      ),
    );
  }
  
  void _showOrderConfirmationDialog(dynamic order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Order Placed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your order has been placed successfully!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Order #${order.id}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Estimated delivery on ${_deliveryDate.month}/${_deliveryDate.day}/${_deliveryDate.year}, $_selectedDeliveryTime',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
              // TODO: Navigate to order history or home screen
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: cartProvider.isEmpty
          ? _buildEmptyCart()
          : _buildPaymentForm(cartProvider),
    );
  }
  
  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Please add some meals to your cart before proceeding to payment.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 24),
          
          CustomButton(
            text: 'Browse Meals',
            onPressed: () {
              Navigator.pop(context);
              // Navigate to home/browse screen
              // TODO: Implement navigation to home screen
            },
            icon: Icons.restaurant_menu,
          ),
        ],
      ),
    );
  }
  
  Widget _buildPaymentForm(CartProvider cartProvider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Form fields
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Information
                  const Text(
                    'Delivery Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Name
                  CustomTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    prefixIcon: Icons.person,
                    validator: Validators.name,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Address
                  CustomTextField(
                    controller: _addressController,
                    label: 'Delivery Address',
                    hint: 'Enter your delivery address',
                    prefixIcon: Icons.location_on,
                    validator: Validators.required,
                    maxLines: 3,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Delivery date
                  GestureDetector(
                    onTap: () => _selectDeliveryDate(context),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        controller: TextEditingController(
                          text: '${_deliveryDate.month}/${_deliveryDate.day}/${_deliveryDate.year}',
                        ),
                        label: 'Delivery Date',
                        prefixIcon: Icons.calendar_today,
                        validator: Validators.required,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Delivery time
                  DropdownButtonFormField<String>(
                    value: _selectedDeliveryTime,
                    decoration: InputDecoration(
                      labelText: 'Delivery Time',
                      prefixIcon: const Icon(Icons.access_time),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: AppConstants.deliveryTimeSlots.map((String time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedDeliveryTime = newValue;
                        });
                      }
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Payment Information
                  const Text(
                    'Payment Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Payment method
                  DropdownButtonFormField<String>(
                    value: _selectedPaymentMethod,
                    decoration: InputDecoration(
                      labelText: 'Payment Method',
                      prefixIcon: const Icon(Icons.payment),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: AppConstants.paymentMethods.map((String method) {
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedPaymentMethod = newValue;
                        });
                      }
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Credit card fields (only show for Credit Card payment method)
                  if (_selectedPaymentMethod == 'Credit Card')
                    Column(
                      children: [
                        // Card number
                        CustomTextField(
                          controller: _cardNumberController,
                          label: 'Card Number',
                          hint: 'XXXX XXXX XXXX XXXX',
                          prefixIcon: Icons.credit_card,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16),
                            _CardNumberFormatter(),
                          ],
                          validator: Validators.creditCardNumber,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Expiry date and CVV in a row
                        Row(
                          children: [
                            // Expiry date
                            Expanded(
                              child: CustomTextField(
                                controller: _expiryDateController,
                                label: 'Expiry Date',
                                hint: 'MM/YY',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                  _ExpiryDateFormatter(),
                                ],
                                validator: Validators.expiryDate,
                              ),
                            ),
                            
                            const SizedBox(width: 16),
                            
                            // CVV
                            Expanded(
                              child: CustomTextField(
                                controller: _cvvController,
                                label: 'CVV',
                                hint: 'XXX',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                validator: Validators.cvv,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Zip code
                        CustomTextField(
                          controller: _zipCodeController,
                          label: 'Billing Zip Code',
                          hint: 'XXXXX',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(5),
                          ],
                          validator: Validators.zipCode,
                        ),
                      ],
                    ),
                  
                  // Space for bottom summary
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          
          // Order summary and place order button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total (${cartProvider.totalItemCount} items):',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${cartProvider.grandTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Place order button
                CustomButton(
                  text: 'Place Order',
                  onPressed: _placeOrder,
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Text input formatter for credit card number (adds spaces after every 4 digits)
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // Remove all existing spaces
    String text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    
    // Add a space after every 4 digits
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        buffer.write(' ');
      }
    }
    
    final String formatted = buffer.toString();
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }
}

// Text input formatter for expiry date (adds / after the first 2 digits)
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // Remove all existing slashes
    String text = newValue.text.replaceAll('/', '');
    
    // Format as MM/YY
    if (text.length > 2) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }
    
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: text.length,
      ),
    );
  }
}
