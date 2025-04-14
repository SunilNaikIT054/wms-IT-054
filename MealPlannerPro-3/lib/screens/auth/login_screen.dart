import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import '../../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                    height: 120,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.restaurant,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Welcome text
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Login to access your meal plans, orders, and more',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 32),
                  
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
                  
                  // Password field
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    validator: Validators.password,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Remember me & Forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remember me checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: Theme.of(context).primaryColor,
                          ),
                          const Text('Remember me'),
                        ],
                      ),
                      
                      // Forgot password link
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Login button
                  CustomButton(
                    onPressed: authProvider.isLoading ? null : _login,
                    text: 'Login',
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
                  
                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text('Sign Up'),
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
