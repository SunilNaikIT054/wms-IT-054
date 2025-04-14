import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuart,
      ),
    );
    
    _animationController.forward();
    
    _navigateToNextScreen();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _navigateToNextScreen() async {
    // Give time for animation and loading state
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    // Check if user is logged in
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => authProvider.isLoggedIn 
            ? const HomeScreen() 
            : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.restaurant,
                        size: 70,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // App name
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'MealAwe',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Tagline
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Delicious Meals, Delivered',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Loading indicator
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
