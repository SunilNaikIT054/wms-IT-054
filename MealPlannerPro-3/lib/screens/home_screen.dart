import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/meal_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';
import 'meal_plans_screen.dart';
import 'checkout_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  final List<String> _filterTags = [];
  
  final List<String> _availableTags = [
    'Seafood',
    'Chicken',
    'Vegetarian',
    'Low-carb',
    'High-protein',
    'Gluten-free',
    'Vegan-option',
    'Low-calorie',
    'Mediterranean',
  ];
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  void _toggleTag(String tag) {
    setState(() {
      if (_filterTags.contains(tag)) {
        _filterTags.remove(tag);
      } else {
        _filterTags.add(tag);
      }
    });
  }
  
  void _clearFilters() {
    setState(() {
      _filterTags.clear();
      _searchQuery = '';
      _searchController.clear();
    });
  }
  
  void _performSearch(String query) {
    setState(() {
      _searchQuery = query.trim();
    });
  }
  
  void _navigateToMealDetail(String mealId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailScreen(mealId: mealId),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Get providers
    final authProvider = Provider.of<AuthProvider>(context);
    final mealProvider = Provider.of<MealProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    
    // Determine which screen to show based on selected index
    Widget currentScreen;
    
    switch (_selectedIndex) {
      case 0:
        currentScreen = _buildHomeContent(mealProvider);
        break;
      case 1:
        currentScreen = const MealPlansScreen();
        break;
      case 2:
        currentScreen = const CheckoutScreen();
        break;
      case 3:
        currentScreen = const ProfileScreen();
        break;
      default:
        currentScreen = _buildHomeContent(mealProvider);
    }
    
    return Scaffold(
      appBar: _buildAppBar(authProvider, cartProvider),
      body: currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Meal Plans',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart),
                if (cartProvider.totalItemCount > 0)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        cartProvider.totalItemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
  
  PreferredSizeWidget _buildAppBar(AuthProvider authProvider, CartProvider cartProvider) {
    // Home screen app bar with search
    if (_selectedIndex == 0) {
      return AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search meals...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                autofocus: true,
                onSubmitted: _performSearch,
              )
            : const Text('MealAwe'),
        actions: [
          // Search icon
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
          
          // Filter icon
          IconButton(
            icon: Badge(
              isLabelVisible: _filterTags.isNotEmpty,
              label: Text(_filterTags.length.toString()),
              child: const Icon(Icons.tune),
            ),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
          
          // Cart icon with badge
          if (!_isSearching)
            IconButton(
              icon: Badge(
                isLabelVisible: cartProvider.totalItemCount > 0,
                label: Text(cartProvider.totalItemCount.toString()),
                child: const Icon(Icons.shopping_cart),
              ),
              onPressed: () {
                _onItemTapped(2); // Switch to cart tab
              },
            ),
        ],
      );
    }
    
    // Other screens app bar
    String title;
    switch (_selectedIndex) {
      case 1:
        title = 'Meal Plans';
        break;
      case 2:
        title = 'Your Cart';
        break;
      case 3:
        title = 'Profile';
        break;
      default:
        title = 'MealAwe';
    }
    
    return AppBar(
      title: Text(title),
      actions: [
        if (_selectedIndex != 2) // Don't show cart on cart screen
          IconButton(
            icon: Badge(
              isLabelVisible: cartProvider.totalItemCount > 0,
              label: Text(cartProvider.totalItemCount.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              _onItemTapped(2); // Switch to cart tab
            },
          ),
      ],
    );
  }
  
  Widget _buildHomeContent(MealProvider mealProvider) {
    if (mealProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    // Apply filters and search
    List<dynamic> mealsToDisplay = mealProvider.meals;
    
    // Apply tag filters
    if (_filterTags.isNotEmpty) {
      mealsToDisplay = mealProvider.filterMealsByTags(_filterTags);
    }
    
    // Apply search query if not empty
    if (_searchQuery.isNotEmpty) {
      final lowerCaseQuery = _searchQuery.toLowerCase();
      mealsToDisplay = mealsToDisplay.where((meal) {
        return meal.name.toLowerCase().contains(lowerCaseQuery) ||
          meal.description.toLowerCase().contains(lowerCaseQuery) ||
          meal.tags.any((tag) => tag.toLowerCase().contains(lowerCaseQuery));
      }).toList();
    }
    
    if (mealProvider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              mealProvider.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                mealProvider.fetchMeals();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    // If no meals found
    if (mealsToDisplay.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No meals found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try different search terms'
                  : 'Try different filters',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _clearFilters,
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      );
    }
    
    // Show results with filters or search applied
    if (_filterTags.isNotEmpty || _searchQuery.isNotEmpty) {
      return Column(
        children: [
          // Filter tags and search summary
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Results: ${mealsToDisplay.length} meals',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear All'),
                    ),
                  ],
                ),
                if (_searchQuery.isNotEmpty)
                  Chip(
                    label: Text('Search: $_searchQuery'),
                    onDeleted: () {
                      setState(() {
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  ),
                if (_filterTags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: _filterTags.map((tag) => Chip(
                      label: Text(tag),
                      onDeleted: () => _toggleTag(tag),
                    )).toList(),
                  ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mealsToDisplay.length,
              itemBuilder: (context, index) {
                final meal = mealsToDisplay[index];
                return MealCard(
                  meal: meal,
                  onTap: () => _navigateToMealDetail(meal.id),
                );
              },
            ),
          ),
        ],
      );
    }
    
    // Default view with featured meals and all meals
    return RefreshIndicator(
      onRefresh: () => mealProvider.fetchMeals(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured meals section
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Featured Meals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            SizedBox(
              height: 220,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: mealProvider.featuredMeals.length,
                itemBuilder: (context, index) {
                  final meal = mealProvider.featuredMeals[index];
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 16),
                    child: MealCard(
                      meal: meal,
                      isCompact: true,
                      onTap: () => _navigateToMealDetail(meal.id),
                    ),
                  );
                },
              ),
            ),
            
            // All meals section
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'All Meals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: mealProvider.meals.length,
              itemBuilder: (context, index) {
                final meal = mealProvider.meals[index];
                return MealCard(
                  meal: meal,
                  onTap: () => _navigateToMealDetail(meal.id),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              maxChildSize: 0.9,
              minChildSize: 0.4,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Filter Meals',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _filterTags.clear();
                              });
                            },
                            child: const Text('Clear All'),
                          ),
                        ],
                      ),
                    ),
                    
                    const Divider(),
                    
                    // Filter options
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        children: [
                          // Tags section
                          const Text(
                            'Meal Tags',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          Wrap(
                            spacing: 8,
                            children: _availableTags.map((tag) {
                              final isSelected = _filterTags.contains(tag);
                              return FilterChip(
                                label: Text(tag),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _filterTags.add(tag);
                                    } else {
                                      _filterTags.remove(tag);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                    
                    // Apply button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Filters are already applied via setState
                          this.setState(() {});
                        },
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
