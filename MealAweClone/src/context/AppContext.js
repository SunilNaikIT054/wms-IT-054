import React, { createContext, useContext, useState, useEffect } from 'react';
import sampleRecipes from '../data/recipes';

// Create Context
const AppContext = createContext();

// Provider Component
export const AppProvider = ({ children }) => {
  const [recipes, setRecipes] = useState([]);
  const [featuredRecipes, setFeaturedRecipes] = useState([]);
  const [popularRecipes, setPopularRecipes] = useState([]);
  const [favorites, setFavorites] = useState([]);
  const [mealPlans, setMealPlans] = useState({});
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  
  // Initialize data
  useEffect(() => {
    const initializeData = async () => {
      setLoading(true);
      
      try {
        // Load recipes
        const loadedRecipes = sampleRecipes;
        setRecipes(loadedRecipes);
        
        // Set featured recipes (top 8)
        setFeaturedRecipes(loadedRecipes.filter(recipe => recipe.featured).slice(0, 8));
        
        // Set popular recipes (based on rating)
        setPopularRecipes(
          [...loadedRecipes]
            .sort((a, b) => (b.rating || 0) - (a.rating || 0))
            .slice(0, 8)
        );
        
        // Load favorites from localStorage
        const savedFavorites = localStorage.getItem('mealAwe_favorites');
        if (savedFavorites) {
          setFavorites(JSON.parse(savedFavorites));
        }
        
        // Load meal plans from localStorage
        const savedMealPlans = localStorage.getItem('mealAwe_mealPlans');
        if (savedMealPlans) {
          setMealPlans(JSON.parse(savedMealPlans));
        }
        
        // Load user from localStorage (for persistence)
        const savedUser = localStorage.getItem('mealAwe_user');
        if (savedUser) {
          setUser(JSON.parse(savedUser));
        }
      } catch (error) {
        console.error('Error initializing data:', error);
      } finally {
        setLoading(false);
      }
    };
    
    initializeData();
  }, []);
  
  // Save favorites to localStorage whenever it changes
  useEffect(() => {
    localStorage.setItem('mealAwe_favorites', JSON.stringify(favorites));
  }, [favorites]);
  
  // Save meal plans to localStorage whenever it changes
  useEffect(() => {
    localStorage.setItem('mealAwe_mealPlans', JSON.stringify(mealPlans));
  }, [mealPlans]);
  
  // Add recipe to favorites
  const addToFavorites = (recipe) => {
    setFavorites(prev => [...prev, recipe]);
  };
  
  // Remove recipe from favorites
  const removeFromFavorites = (recipeId) => {
    setFavorites(prev => prev.filter(recipe => recipe.id !== recipeId));
  };
  
  // Update meal plan for a specific date
  const updateMealPlan = (date, mealPlan) => {
    setMealPlans(prev => ({
      ...prev,
      [date]: mealPlan
    }));
  };
  
  // Add recipe to meal plan
  const addToMealPlan = (date, mealType, recipe) => {
    setMealPlans(prev => {
      const currentPlan = prev[date] || {};
      const currentMeals = currentPlan[mealType] || [];
      
      // Check if recipe is already in the meal plan
      const isAlreadyAdded = currentMeals.some(meal => meal.id === recipe.id);
      
      if (isAlreadyAdded) return prev;
      
      const updatedMeals = [...currentMeals, recipe];
      
      return {
        ...prev,
        [date]: {
          ...currentPlan,
          [mealType]: updatedMeals
        }
      };
    });
  };
  
  // Remove recipe from meal plan
  const removeFromMealPlan = (date, mealType, recipeId) => {
    setMealPlans(prev => {
      const currentPlan = prev[date];
      if (!currentPlan || !currentPlan[mealType]) return prev;
      
      const updatedMeals = currentPlan[mealType].filter(meal => meal.id !== recipeId);
      
      return {
        ...prev,
        [date]: {
          ...currentPlan,
          [mealType]: updatedMeals
        }
      };
    });
  };
  
  // Login user
  const login = (userData) => {
    setUser(userData);
    localStorage.setItem('mealAwe_user', JSON.stringify(userData));
  };
  
  // Logout user
  const logout = () => {
    setUser(null);
    localStorage.removeItem('mealAwe_user');
  };
  
  // Context value
  const value = {
    recipes,
    featuredRecipes,
    popularRecipes,
    favorites,
    mealPlans,
    user,
    loading,
    addToFavorites,
    removeFromFavorites,
    updateMealPlan,
    addToMealPlan,
    removeFromMealPlan,
    login,
    logout
  };
  
  return <AppContext.Provider value={value}>{children}</AppContext.Provider>;
};

// Custom hook to use the app context
export const useAppContext = () => {
  const context = useContext(AppContext);
  if (context === undefined) {
    throw new Error('useAppContext must be used within an AppProvider');
  }
  return context;
};
