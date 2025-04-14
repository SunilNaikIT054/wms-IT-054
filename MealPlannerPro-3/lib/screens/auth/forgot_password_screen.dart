import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../utils/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _resetEmailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.resetPassword(
      email: _emailController.text.trim(),
    );
    
    if (success && mounted) {
      setState(() {
        _resetEmailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: _resetEmailSent
                ? _buildSuccessView(context)
                : _buildResetForm(context, authProvider),
          );
        },
      ),
    );
  }

  Widget _buildResetForm(BuildContext context, AuthProvider authProvider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon
          Container(
            height: 120,
            alignment: Alignment.center,
            child: Icon(
              Icons.lock_reset,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Header text
          Text(
            'Forgot Password',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Enter your email address to receive a password reset link',
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
          
          const SizedBox(height: 24),
          
          // Reset button
          CustomButton(
            onPressed: authProvider.isLoading ? null : _resetPassword,
            text: 'Reset Password',
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
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.mark_email_read,
          size: 80,
          color: Theme.of(context).primaryColor,
        ),
        
        const SizedBox(height: 24),
        
        Text(
          'Check Your Email',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        Text(
          'We\'ve sent a password reset link to:\n${_emailController.text}',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        Text(
          'Please check your email and follow the instructions to reset your password.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        CustomButton(
          onPressed: () {
            Navigator.pop(context);
          },
          text: 'Back to Login',
          isOutlined: true,
        ),
      ],
    );
  }
}
