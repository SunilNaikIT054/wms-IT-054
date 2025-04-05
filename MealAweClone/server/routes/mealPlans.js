const express = require('express');
const fs = require('fs');
const path = require('path');
const router = express.Router();

// Path to the meal plans JSON file
const mealPlansFilePath = path.join(__dirname, '../data/mealPlans.json');

// Helper function to read meal plans from file
const getMealPlans = () => {
  try {
    const data = fs.readFileSync(mealPlansFilePath, 'utf8');
    return JSON.parse(data);
  } catch (error) {
    console.error('Error reading meal plans file:', error);
    return {};
  }
};

// Helper function to write meal plans to file
const saveMealPlans = (mealPlans) => {
  try {
    fs.writeFileSync(mealPlansFilePath, JSON.stringify(mealPlans, null, 2), 'utf8');
    return true;
  } catch (error) {
    console.error('Error writing meal plans file:', error);
    return false;
  }
};

// Get all meal plans
router.get('/', (req, res) => {
  try {
    const mealPlans = getMealPlans();
    
    // Filter by user if user ID is provided
    let filteredMealPlans = mealPlans;
    if (req.query.userId) {
      filteredMealPlans = {};
      
      for (const [date, plan] of Object.entries(mealPlans)) {
        if (plan.userId === req.query.userId) {
          filteredMealPlans[date] = plan;
        }
      }
    }
    
    res.json({
      success: true,
      count: Object.keys(filteredMealPlans).length,
      data: filteredMealPlans
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error retrieving meal plans',
      error: error.message
    });
  }
});

// === SPECIFIC ROUTES FIRST ===

// Get meal plans for a date range - must be before /:date route
router.get('/range/:startDate/:endDate', (req, res) => {
  try {
    const mealPlans = getMealPlans();
    const { startDate, endDate } = req.params;
    
    // Validate dates
    const start = new Date(startDate);
    const end = new Date(endDate);
    
    if (isNaN(start.getTime()) || isNaN(end.getTime())) {
      return res.status(400).json({
        success: false,
        message: 'Invalid date format. Use YYYY-MM-DD format.'
      });
    }
    
    // Filter meal plans in date range
    const dateRangePlans = {};
    
    for (const [date, plan] of Object.entries(mealPlans)) {
      const planDate = new Date(date);
      
      if (planDate >= start && planDate <= end) {
        // Filter by user if user ID is provided
        if (!req.query.userId || plan.userId === req.query.userId) {
          dateRangePlans[date] = plan;
        }
      }
    }
    
    res.json({
      success: true,
      data: dateRangePlans
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error retrieving meal plans',
      error: error.message
    });
  }
});

// Generate grocery list from meal plans - must be before /:date route
router.get('/grocery-list/:startDate/:endDate', (req, res) => {
  try {
    const mealPlans = getMealPlans();
    const { startDate, endDate } = req.params;
    
    // Validate dates
    const start = new Date(startDate);
    const end = new Date(endDate);
    
    if (isNaN(start.getTime()) || isNaN(end.getTime())) {
      return res.status(400).json({
        success: false,
        message: 'Invalid date format. Use YYYY-MM-DD format.'
      });
    }
    
    // Get all recipes from meal plans in date range
    const recipes = [];
    const mealTypes = ['breakfast', 'lunch', 'dinner', 'snacks'];
    
    for (const [date, plan] of Object.entries(mealPlans)) {
      const planDate = new Date(date);
      
      if (planDate >= start && planDate <= end) {
        // Filter by user if user ID is provided
        if (!req.query.userId || plan.userId === req.query.userId) {
          mealTypes.forEach(mealType => {
            if (plan[mealType] && Array.isArray(plan[mealType])) {
              recipes.push(...plan[mealType]);
            }
          });
        }
      }
    }
    
    // Extract ingredients from recipes
    const groceryItems = {};
    
    recipes.forEach(recipe => {
      if (recipe.ingredients && Array.isArray(recipe.ingredients)) {
        recipe.ingredients.forEach(ingredient => {
          const category = ingredient.category || 'Other';
          
          if (!groceryItems[category]) {
            groceryItems[category] = [];
          }
          
          // Check if ingredient already exists in the category
          const existingItemIndex = groceryItems[category].findIndex(
            item => item.name.toLowerCase() === ingredient.name.toLowerCase()
          );
          
          if (existingItemIndex >= 0) {
            // Update quantity if needed
            if (ingredient.quantity && groceryItems[category][existingItemIndex].quantity) {
              const existingQty = parseFloat(groceryItems[category][existingItemIndex].quantity) || 0;
              const newQty = parseFloat(ingredient.quantity) || 0;
              groceryItems[category][existingItemIndex].quantity = (existingQty + newQty).toString();
            }
          } else {
            // Add new ingredient
            groceryItems[category].push({
              ...ingredient,
              id: `${category}-${ingredient.name}`.replace(/\s+/g, '-').toLowerCase()
            });
          }
        });
      }
    });
    
    res.json({
      success: true,
      data: groceryItems
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error generating grocery list',
      error: error.message
    });
  }
});

// === PARAMETER ROUTES AFTER SPECIFIC ONES ===

// Get meal plan for a specific date - must be after other GET routes with more specific patterns
router.get('/:date', (req, res) => {
  try {
    const mealPlans = getMealPlans();
    const { date } = req.params;
    
    if (!mealPlans[date]) {
      return res.status(404).json({
        success: false,
        message: 'No meal plan found for this date'
      });
    }
    
    // Filter by user if user ID is provided
    if (req.query.userId && mealPlans[date].userId !== req.query.userId) {
      return res.status(403).json({
        success: false,
        message: 'You do not have access to this meal plan'
      });
    }
    
    res.json({
      success: true,
      data: mealPlans[date]
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error retrieving meal plan',
      error: error.message
    });
  }
});

// Create or update meal plan for a specific date
router.post('/:date', (req, res) => {
  try {
    const mealPlans = getMealPlans();
    const { date } = req.params;
    
    // Validate required fields
    if (!req.body) {
      return res.status(400).json({
        success: false,
        message: 'Meal plan data is required'
      });
    }
    
    // Create or update meal plan
    mealPlans[date] = {
      ...req.body,
      updatedAt: new Date().toISOString()
    };
    
    // Save updated meal plans
    if (saveMealPlans(mealPlans)) {
      res.json({
        success: true,
        message: 'Meal plan saved successfully',
        data: mealPlans[date]
      });
    } else {
      throw new Error('Failed to save meal plan');
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error saving meal plan',
      error: error.message
    });
  }
});

// Add a recipe to a meal plan
router.post('/:date/meals/:mealType', (req, res) => {
  try {
    const mealPlans = getMealPlans();
    const { date, mealType } = req.params;
    
    // Validate meal type
    const validMealTypes = ['breakfast', 'lunch', 'dinner', 'snacks'];
    if (!validMealTypes.includes(mealType)) {
      return res.status(400).json({
        success: false,
        message: `Invalid meal type. Must be one of: ${validMealTypes.join(', ')}`
      });
    }
    
    // Validate required fields
    if (!req.body.recipe || !req.body.recipe.id) {
      return res.status(400).json({
        success: false,
        message: 'Recipe is required'
      });
    }
    
    // Initialize meal plan for date if it doesn't exist
    if (!mealPlans[date]) {
      mealPlans[date] = {
        userId: req.body.userId,
        createdAt: new Date().toISOString()
      };
    }
    
    // Initialize meal type array if it doesn't exist
    if (!mealPlans[date][mealType]) {
      mealPlans[date][mealType] = [];
    }
    
    // Check if recipe is already in the meal plan
    const existingIndex = mealPlans[date][mealType].findIndex(
      meal => meal.id === req.body.recipe.id
    );
    
    if (existingIndex >= 0) {
      // Update existing recipe
      mealPlans[date][mealType][existingIndex] = req.body.recipe;
    } else {
      // Add new recipe
      mealPlans[date][mealType].push(req.body.recipe);
    }
    
    mealPlans[date].updatedAt = new Date().toISOString();
    
    // Save updated meal plans
    if (saveMealPlans(mealPlans)) {
      res.json({
        success: true,
        message: 'Recipe added to meal plan successfully',
        data: mealPlans[date]
      });
    } else {
      throw new Error('Failed to update meal plan');
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error adding recipe to meal plan',
      error: error.message
    });
  }
});

// Remove a recipe from a meal plan
router.delete('/:date/meals/:mealType/:recipeId', (req, res) => {
  try {
    const mealPlans = getMealPlans();
    const { date, mealType, recipeId } = req.params;
    
    // Check if meal plan and meal type exist
    if (!mealPlans[date] || !mealPlans[date][mealType]) {
      return res.status(404).json({
        success: false,
        message: 'Meal plan or meal type not found'
      });
    }
    
    // Find the recipe in the meal plan
    const recipeIndex = mealPlans[date][mealType].findIndex(
      meal => meal.id === recipeId
    );
    
    if (recipeIndex === -1) {
      return res.status(404).json({
        success: false,
        message: 'Recipe not found in meal plan'
      });
    }
    
    // Remove the recipe
    mealPlans[date][mealType].splice(recipeIndex, 1);
    mealPlans[date].updatedAt = new Date().toISOString();
    
    // Save updated meal plans
    if (saveMealPlans(mealPlans)) {
      res.json({
        success: true,
        message: 'Recipe removed from meal plan successfully',
        data: mealPlans[date]
      });
    } else {
      throw new Error('Failed to update meal plan');
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error removing recipe from meal plan',
      error: error.message
    });
  }
});

// Delete a meal plan for a specific date
router.delete('/:date', (req, res) => {
  try {
    const mealPlans = getMealPlans();
    const { date } = req.params;
    
    if (!mealPlans[date]) {
      return res.status(404).json({
        success: false,
        message: 'Meal plan not found'
      });
    }
    
    // Store the meal plan before deleting
    const deletedMealPlan = mealPlans[date];
    
    // Delete the meal plan
    delete mealPlans[date];
    
    // Save updated meal plans
    if (saveMealPlans(mealPlans)) {
      res.json({
        success: true,
        message: 'Meal plan deleted successfully',
        data: deletedMealPlan
      });
    } else {
      throw new Error('Failed to delete meal plan');
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error deleting meal plan',
      error: error.message
    });
  }
});

module.exports = router;