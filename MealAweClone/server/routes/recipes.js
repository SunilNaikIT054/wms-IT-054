const express = require('express');
const fs = require('fs');
const path = require('path');
const router = express.Router();

// Path to the recipes JSON file
const recipesFilePath = path.join(__dirname, '../data/recipes.json');

// Helper function to read recipes from file
const getRecipes = () => {
  try {
    const data = fs.readFileSync(recipesFilePath, 'utf8');
    return JSON.parse(data);
  } catch (error) {
    console.error('Error reading recipes file:', error);
    return [];
  }
};

// Helper function to write recipes to file
const saveRecipes = (recipes) => {
  try {
    fs.writeFileSync(recipesFilePath, JSON.stringify(recipes, null, 2), 'utf8');
    return true;
  } catch (error) {
    console.error('Error writing recipes file:', error);
    return false;
  }
};

// Get all recipes
router.get('/', (req, res) => {
  try {
    const recipes = getRecipes();
    
    // Filter recipes based on query parameters
    let filteredRecipes = [...recipes];
    
    // Filter by search term
    if (req.query.search) {
      const searchTerm = req.query.search.toLowerCase();
      filteredRecipes = filteredRecipes.filter(recipe => 
        recipe.title.toLowerCase().includes(searchTerm) || 
        (recipe.description && recipe.description.toLowerCase().includes(searchTerm)) ||
        (recipe.ingredients && recipe.ingredients.some(ing => 
          ing.name && ing.name.toLowerCase().includes(searchTerm)
        ))
      );
    }
    
    // Filter by category
    if (req.query.category && req.query.category !== 'all') {
      filteredRecipes = filteredRecipes.filter(recipe => 
        recipe.category === req.query.category || 
        (recipe.tags && recipe.tags.includes(req.query.category))
      );
    }
    
    // Filter by difficulty
    if (req.query.difficulty) {
      filteredRecipes = filteredRecipes.filter(recipe => 
        recipe.difficulty === req.query.difficulty
      );
    }
    
    // Filter by cooking time
    if (req.query.time) {
      const maxTime = parseInt(req.query.time);
      filteredRecipes = filteredRecipes.filter(recipe => 
        recipe.cookTime <= maxTime
      );
    }
    
    // Filter by dietary restrictions
    if (req.query.dietary) {
      filteredRecipes = filteredRecipes.filter(recipe => 
        recipe.dietary === req.query.dietary || 
        (recipe.tags && recipe.tags.includes(req.query.dietary))
      );
    }
    
    // Sort recipes
    if (req.query.sort) {
      switch (req.query.sort) {
        case 'popular':
          filteredRecipes.sort((a, b) => (b.rating || 0) - (a.rating || 0));
          break;
        case 'newest':
          // Assuming recipes have a createdAt field
          filteredRecipes.sort((a, b) => 
            new Date(b.createdAt || 0) - new Date(a.createdAt || 0)
          );
          break;
        default:
          break;
      }
    }
    
    // Pagination
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || filteredRecipes.length;
    const startIndex = (page - 1) * limit;
    const endIndex = page * limit;
    
    const paginatedRecipes = filteredRecipes.slice(startIndex, endIndex);
    
    res.json({
      success: true,
      count: filteredRecipes.length,
      data: paginatedRecipes
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error retrieving recipes',
      error: error.message
    });
  }
});

// Search recipes
router.get('/search/:term', (req, res) => {
  try {
    const recipes = getRecipes();
    const searchTerm = req.params.term.toLowerCase();
    
    const results = recipes.filter(recipe => 
      recipe.title.toLowerCase().includes(searchTerm) || 
      (recipe.description && recipe.description.toLowerCase().includes(searchTerm)) ||
      (recipe.ingredients && recipe.ingredients.some(ing => 
        ing.name && ing.name.toLowerCase().includes(searchTerm)
      )) ||
      (recipe.tags && recipe.tags.some(tag => 
        tag.toLowerCase().includes(searchTerm)
      ))
    );
    
    res.json({
      success: true,
      count: results.length,
      data: results
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error searching recipes',
      error: error.message
    });
  }
});

// Get featured recipes
router.get('/featured/list', (req, res) => {
  try {
    const recipes = getRecipes();
    const featured = recipes.filter(recipe => recipe.featured);
    
    res.json({
      success: true,
      count: featured.length,
      data: featured
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error retrieving featured recipes',
      error: error.message
    });
  }
});

// Get recipe by ID (must be defined after more specific routes to avoid conflicts)
router.get('/:id', (req, res) => {
  try {
    const recipes = getRecipes();
    const recipe = recipes.find(r => r.id === req.params.id);
    
    if (!recipe) {
      return res.status(404).json({
        success: false,
        message: 'Recipe not found'
      });
    }
    
    res.json({
      success: true,
      data: recipe
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error retrieving recipe',
      error: error.message
    });
  }
});

// Create new recipe
router.post('/', (req, res) => {
  try {
    const recipes = getRecipes();
    
    // Validate required fields
    if (!req.body.title || !req.body.category) {
      return res.status(400).json({
        success: false,
        message: 'Title and category are required fields'
      });
    }
    
    // Create a new recipe
    const newRecipe = {
      id: `r${Date.now()}`, // Generate unique ID
      ...req.body,
      createdAt: new Date().toISOString()
    };
    
    recipes.push(newRecipe);
    
    // Save updated recipes list
    if (saveRecipes(recipes)) {
      res.status(201).json({
        success: true,
        message: 'Recipe created successfully',
        data: newRecipe
      });
    } else {
      throw new Error('Failed to save recipe');
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error creating recipe',
      error: error.message
    });
  }
});

// Update recipe
router.put('/:id', (req, res) => {
  try {
    const recipes = getRecipes();
    const index = recipes.findIndex(r => r.id === req.params.id);
    
    if (index === -1) {
      return res.status(404).json({
        success: false,
        message: 'Recipe not found'
      });
    }
    
    // Update recipe
    const updatedRecipe = {
      ...recipes[index],
      ...req.body,
      id: req.params.id, // Ensure ID remains the same
      updatedAt: new Date().toISOString()
    };
    
    recipes[index] = updatedRecipe;
    
    // Save updated recipes list
    if (saveRecipes(recipes)) {
      res.json({
        success: true,
        message: 'Recipe updated successfully',
        data: updatedRecipe
      });
    } else {
      throw new Error('Failed to update recipe');
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error updating recipe',
      error: error.message
    });
  }
});

// Delete recipe
router.delete('/:id', (req, res) => {
  try {
    const recipes = getRecipes();
    const index = recipes.findIndex(r => r.id === req.params.id);
    
    if (index === -1) {
      return res.status(404).json({
        success: false,
        message: 'Recipe not found'
      });
    }
    
    // Remove recipe
    const deletedRecipe = recipes.splice(index, 1)[0];
    
    // Save updated recipes list
    if (saveRecipes(recipes)) {
      res.json({
        success: true,
        message: 'Recipe deleted successfully',
        data: deletedRecipe
      });
    } else {
      throw new Error('Failed to delete recipe');
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error deleting recipe',
      error: error.message
    });
  }
});

module.exports = router;
