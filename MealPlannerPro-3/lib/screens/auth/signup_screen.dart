import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../utils/validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must agree to the Terms & Conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.signUp(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phoneNumber: _phoneController.text.trim(),
    );
    
    if (success && mounted) {
      // Navigate back to login or home
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo or header image
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.restaurant,
                      size: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Header text
                  Text(
                    'Create an Account',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Sign up to start enjoying fresh, delicious meals',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Name field
                  CustomTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    prefixIcon: Icons.person,
                    validator: Validators.name,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Email field
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Phone field
                  CustomTextField(
                    controller: _phoneController,
                    label: 'Phone Number (Optional)',
                    hint: 'Enter your phone number',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: Validators.phoneOptional,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Password field
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    validator: Validators.password,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Confirm Password field
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) => Validators.confirmPassword(
                      value, 
                      _passwordController.text,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Terms and conditions checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _agreedToTerms = !_agreedToTerms;
                            });
                          },
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'I agree to the ',
                                ),
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' and ',
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sign up button
                  CustomButton(
                    onPressed: authProvider.isLoading ? null : _signup,
                    text: 'Sign Up',
                    isLoading: authProvider.isLoading,
                    isFullWidth: true,
                  ),
                  
                  // Error message
                  if (authProvider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        authProvider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
