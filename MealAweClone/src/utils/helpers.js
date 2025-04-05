/**
 * Helper utility functions for the MealAwe application
 */

/**
 * Formats a date as a string in the format "YYYY-MM-DD"
 * @param {Date} date - The date to format
 * @returns {string} The formatted date string
 */
export const formatDate = (date) => {
  return date.toISOString().split('T')[0];
};

/**
 * Formats a date to display the day name and date (e.g., "Monday, Jan 1")
 * @param {string} dateString - The date string in "YYYY-MM-DD" format
 * @returns {string} The formatted date display string
 */
export const formatDisplayDate = (dateString) => {
  const options = { weekday: 'long', month: 'short', day: 'numeric' };
  return new Date(dateString).toLocaleDateString('en-US', options);
};

/**
 * Generates an array of dates for the next n days
 * @param {number} days - Number of days to generate
 * @returns {Array} Array of date objects with date and label properties
 */
export const generateDateOptions = (days = 14) => {
  const dates = [];
  const today = new Date();
  
  for (let i = 0; i < days; i++) {
    const date = new Date(today);
    date.setDate(today.getDate() + i);
    const dateString = formatDate(date);
    
    dates.push({
      date: dateString,
      label: formatDisplayDate(dateString)
    });
  }
  
  return dates;
};

/**
 * Generates a range of dates for a week starting from the specified date
 * @param {Date} startDate - The starting date for the week
 * @returns {Array} Array of date objects for the week
 */
export const generateWeekDates = (startDate) => {
  const dates = [];
  const start = new Date(startDate);
  
  for (let i = 0; i < 7; i++) {
    const date = new Date(start);
    date.setDate(start.getDate() + i);
    
    dates.push({
      date: formatDate(date),
      dayOfWeek: i,
    });
  }
  
  return dates;
};

/**
 * Formats the range of dates for a week (e.g., "Jan 1 - Jan 7")
 * @param {Array} weekDates - Array of date objects for the week
 * @returns {string} Formatted date range string
 */
export const formatWeekRange = (weekDates) => {
  if (!weekDates || weekDates.length === 0) return '';
  
  const firstDay = new Date(weekDates[0].date);
  const lastDay = new Date(weekDates[6].date);
  
  const options = { month: 'short', day: 'numeric' };
  return `${firstDay.toLocaleDateString('en-US', options)} - ${lastDay.toLocaleDateString('en-US', options)}`;
};

/**
 * Calculates the total calories for a meal plan
 * @param {Object} mealPlan - The meal plan object containing meal arrays
 * @returns {number} Total calories
 */
export const calculateTotalCalories = (mealPlan) => {
  if (!mealPlan) return 0;
  
  let total = 0;
  const mealTypes = ['breakfast', 'lunch', 'dinner', 'snacks'];
  
  mealTypes.forEach(type => {
    if (mealPlan[type] && Array.isArray(mealPlan[type])) {
      mealPlan[type].forEach(meal => {
        total += meal.calories || 0;
      });
    }
  });
  
  return total;
};

/**
 * Groups grocery items by their categories
 * @param {Array} items - Array of grocery items
 * @returns {Object} Object with categories as keys and arrays of items as values
 */
export const groupGroceryItemsByCategory = (items) => {
  const grouped = {};
  
  items.forEach(item => {
    const category = item.category || 'Other';
    
    if (!grouped[category]) {
      grouped[category] = [];
    }
    
    // Check if item already exists in the category
    const existingItem = grouped[category].find(
      existing => existing.name.toLowerCase() === item.name.toLowerCase()
    );
    
    if (existingItem) {
      // Update quantity if item exists
      if (item.quantity && existingItem.quantity) {
        const existingQty = parseFloat(existingItem.quantity) || 0;
        const newQty = parseFloat(item.quantity) || 0;
        existingItem.quantity = (existingQty + newQty).toString();
      }
    } else {
      // Add new item to category
      grouped[category].push({
        ...item,
        id: `${category}-${item.name}`.replace(/\s+/g, '-').toLowerCase()
      });
    }
  });
  
  return grouped;
};

/**
 * Filters recipes based on search criteria
 * @param {Array} recipes - Array of recipe objects
 * @param {Object} filters - Object containing filter criteria
 * @returns {Array} Filtered array of recipes
 */
export const filterRecipes = (recipes, filters) => {
  if (!recipes || !Array.isArray(recipes)) return [];
  if (!filters) return recipes;
  
  return recipes.filter(recipe => {
    // Filter by search term
    if (filters.searchTerm) {
      const term = filters.searchTerm.toLowerCase();
      const matchesTitle = recipe.title.toLowerCase().includes(term);
      const matchesDescription = recipe.description && recipe.description.toLowerCase().includes(term);
      const matchesIngredient = recipe.ingredients && 
        recipe.ingredients.some(ing => 
          ing.name && ing.name.toLowerCase().includes(term)
        );
      
      if (!(matchesTitle || matchesDescription || matchesIngredient)) {
        return false;
      }
    }
    
    // Filter by category
    if (filters.category && filters.category !== 'all') {
      const matchesCategory = recipe.category === filters.category;
      const matchesTag = recipe.tags && recipe.tags.includes(filters.category);
      
      if (!(matchesCategory || matchesTag)) {
        return false;
      }
    }
    
    // Filter by difficulty
    if (filters.difficulty && recipe.difficulty !== filters.difficulty) {
      return false;
    }
    
    // Filter by cooking time
    if (filters.time) {
      const maxTime = parseInt(filters.time);
      if (recipe.cookTime > maxTime) {
        return false;
      }
    }
    
    // Filter by dietary restrictions
    if (filters.dietary) {
      const matchesDietary = recipe.dietary === filters.dietary;
      const matchesDietaryTag = recipe.tags && recipe.tags.includes(filters.dietary);
      
      if (!(matchesDietary || matchesDietaryTag)) {
        return false;
      }
    }
    
    return true;
  });
};

/**
 * Gets a default image URL if the provided URL is empty or invalid
 * @param {string} imageUrl - The image URL to check
 * @returns {string} The provided image URL or a default placeholder URL
 */
export const getDefaultImage = (imageUrl) => {
  if (!imageUrl) {
    return "https://via.placeholder.com/300x200/f0f0f0/a0a0a0?text=No+Image";
  }
  return imageUrl;
};

/**
 * Gets an icon for a grocery category
 * @param {string} category - The category name
 * @returns {string} CSS class for the appropriate FontAwesome icon
 */
export const getCategoryIcon = (category) => {
  const icons = {
    'Produce': 'fa-carrot',
    'Dairy': 'fa-cheese',
    'Meat': 'fa-drumstick-bite',
    'Bakery': 'fa-bread-slice',
    'Canned Goods': 'fa-can-food',
    'Dry Goods': 'fa-wheat',
    'Frozen': 'fa-snowflake',
    'Beverages': 'fa-wine-bottle',
    'Condiments': 'fa-sauce',
    'Spices': 'fa-pepper-hot',
    'Other': 'fa-shopping-basket'
  };
  
  return icons[category] || 'fa-shopping-basket';
};

/**
 * Adjusts ingredient quantities based on serving size
 * @param {Array} ingredients - Array of ingredient objects
 * @param {number} originalServings - The original recipe serving size
 * @param {number} targetServings - The desired serving size
 * @returns {Array} Array of ingredients with adjusted quantities
 */
export const adjustIngredientQuantities = (ingredients, originalServings, targetServings) => {
  if (!ingredients || !Array.isArray(ingredients)) return [];
  if (!originalServings || originalServings <= 0) return ingredients;
  
  const multiplier = targetServings / originalServings;
  
  return ingredients.map(ingredient => {
    if (!ingredient.quantity) return ingredient;
    
    const newQuantity = parseFloat(ingredient.quantity) * multiplier;
    
    return {
      ...ingredient,
      quantity: Number.isInteger(newQuantity) ? newQuantity.toString() : newQuantity.toFixed(1)
    };
  });
};
