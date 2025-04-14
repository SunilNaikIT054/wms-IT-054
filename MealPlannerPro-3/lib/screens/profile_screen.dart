import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../utils/validators.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  
  bool _isEditMode = false;
  bool _isUpdating = false;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    
    // Load user data after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
  
  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isLoggedIn && authProvider.user != null) {
      final user = authProvider.user!;
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
      _addressController.text = user.address ?? '';
    }
  }
  
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isUpdating = true;
    });
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final updatedUser = authProvider.user!.copyWith(
      name: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
    );
    
    try {
      await authProvider.updateUserProfile(updatedUser);
      setState(() {
        _isEditMode = false;
        _isUpdating = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              
              // Navigate to home/login screen
              // TODO: Implement navigation to login or home screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (!authProvider.isLoggedIn) {
      return _buildNotLoggedInView();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          // Edit/Save button
          _isEditMode
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _isEditMode = false),
                  tooltip: 'Cancel',
                )
              : IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => setState(() => _isEditMode = true),
                  tooltip: 'Edit Profile',
                ),
          
          // Save button (only show in edit mode)
          if (_isEditMode)
            IconButton(
              icon: _isUpdating
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.check),
              onPressed: _isUpdating ? null : _updateProfile,
              tooltip: 'Save',
            ),
          
          // More options
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'logout':
                  _logout();
                  break;
                case 'account':
                  // TODO: Implement account settings navigation
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'account',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 8),
                    Text('Account Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildProfileContent(authProvider),
    );
  }
  
  Widget _buildNotLoggedInView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle_outlined,
              size: 100,
              color: Colors.grey,
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Not Logged In',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Please log in to view your profile',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 32),
            
            CustomButton(
              text: 'Log In',
              onPressed: () {
                // Navigate to login screen
                // TODO: Implement navigation to login screen
              },
              icon: Icons.login,
            ),
            
            const SizedBox(height: 16),
            
            TextButton(
              onPressed: () {
                // Navigate to signup screen
                // TODO: Implement navigation to signup screen
              },
              child: const Text('Create an Account'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileContent(AuthProvider authProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          _buildProfileHeader(authProvider),
          
          const SizedBox(height: 32),
          
          // Profile form
          _buildProfileForm(),
          
          const SizedBox(height: 32),
          
          // Profile actions
          _buildProfileActions(),
        ],
      ),
    );
  }
  
  Widget _buildProfileHeader(AuthProvider authProvider) {
    return Column(
      children: [
        // Profile picture
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              
              if (_isEditMode)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // User name
        Text(
          authProvider.user?.name ?? 'User',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 4),
        
        // User email
        Text(
          authProvider.user?.email ?? '',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        // Member since
        if (authProvider.user?.createdAt != null)
          Text(
            'Member since ${_formatDate(authProvider.user!.createdAt!)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
  
  Widget _buildProfileForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
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
            readOnly: !_isEditMode,
          ),
          
          const SizedBox(height: 16),
          
          // Email
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email',
            prefixIcon: Icons.email,
            validator: Validators.email,
            readOnly: true, // Email can't be changed
          ),
          
          const SizedBox(height: 16),
          
          // Phone
          CustomTextField(
            controller: _phoneController,
            label: 'Phone',
            hint: 'Enter your phone number',
            prefixIcon: Icons.phone,
            validator: Validators.phone,
            readOnly: !_isEditMode,
          ),
          
          const SizedBox(height: 16),
          
          // Address
          CustomTextField(
            controller: _addressController,
            label: 'Address',
            hint: 'Enter your address',
            prefixIcon: Icons.location_on,
            maxLines: 3,
            readOnly: !_isEditMode,
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfileActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Order history
        _buildActionCard(
          icon: Icons.history,
          title: 'Order History',
          description: 'View your past orders and delivery status',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OrderHistoryScreen(),
              ),
            );
          },
        ),
        
        const SizedBox(height: 12),
        
        // Subscriptions
        _buildActionCard(
          icon: Icons.payments,
          title: 'My Subscriptions',
          description: 'Manage your meal plan subscriptions',
          onTap: () {
            // Navigate to subscriptions screen
            // TODO: Implement navigation to subscriptions screen
          },
        ),
        
        const SizedBox(height: 12),
        
        // Payment methods
        _buildActionCard(
          icon: Icons.credit_card,
          title: 'Payment Methods',
          description: 'Manage your saved payment methods',
          onTap: () {
            // Navigate to payment methods screen
            // TODO: Implement navigation to payment methods screen
          },
        ),
        
        const SizedBox(height: 12),
        
        // Privacy & security
        _buildActionCard(
          icon: Icons.security,
          title: 'Privacy & Security',
          description: 'Update your password and security settings',
          onTap: () {
            // Navigate to privacy & security screen
            // TODO: Implement navigation to privacy & security screen
          },
        ),
        
        const SizedBox(height: 12),
        
        // Help & support
        _buildActionCard(
          icon: Icons.help_outline,
          title: 'Help & Support',
          description: 'Get help with your account or orders',
          onTap: () {
            // Navigate to help & support screen
            // TODO: Implement navigation to help & support screen
          },
        ),
        
        const SizedBox(height: 24),
        
        // Logout button
        Center(
          child: CustomButton(
            text: 'Logout',
            onPressed: _logout,
            icon: Icons.logout,
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: Theme.of(context).primaryColor,
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
