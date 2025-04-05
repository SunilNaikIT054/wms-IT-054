import React, { useState, useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import RecipeCard from '../components/RecipeCard';
import SearchBar from '../components/SearchBar';
import { useAppContext } from '../context/AppContext';

const Recipes = () => {
  const { recipes } = useAppContext();
  const [filteredRecipes, setFilteredRecipes] = useState([]);
  const [loading, setLoading] = useState(false);
  const [activeCategory, setActiveCategory] = useState('all');
  const location = useLocation();

  // Categories for the recipe filters
  const categories = [
    { id: 'all', name: 'All Recipes' },
    { id: 'breakfast', name: 'Breakfast' },
    { id: 'lunch', name: 'Lunch' },
    { id: 'dinner', name: 'Dinner' },
    { id: 'desserts', name: 'Desserts' },
    { id: 'snacks', name: 'Snacks' },
    { id: 'vegetarian', name: 'Vegetarian' },
  ];

  useEffect(() => {
    // Check if there are query params in the URL
    const queryParams = new URLSearchParams(location.search);
    const categoryParam = queryParams.get('category');
    
    if (categoryParam) {
      handleCategoryClick(categoryParam);
    } else {
      setFilteredRecipes(recipes);
    }
  }, [location.search, recipes]);

  const handleSearch = (searchFilters) => {
    setLoading(true);
    
    // Implement filtering logic based on search term and filters
    let results = [...recipes];
    
    // Filter by search term
    if (searchFilters.searchTerm) {
      const term = searchFilters.searchTerm.toLowerCase();
      results = results.filter(recipe => 
        recipe.title.toLowerCase().includes(term) || 
        (recipe.description && recipe.description.toLowerCase().includes(term)) ||
        (recipe.ingredients && recipe.ingredients.some(ing => ing.toLowerCase().includes(term)))
      );
    }
    
    // Filter by category
    if (searchFilters.category) {
      results = results.filter(recipe => 
        recipe.category === searchFilters.category ||
        (recipe.tags && recipe.tags.includes(searchFilters.category))
      );
    }
    
    // Filter by difficulty
    if (searchFilters.difficulty) {
      results = results.filter(recipe => recipe.difficulty === searchFilters.difficulty);
    }
    
    // Filter by cooking time
    if (searchFilters.time) {
      const maxTime = parseInt(searchFilters.time);
      results = results.filter(recipe => recipe.cookTime <= maxTime);
    }
    
    // Filter by dietary restrictions
    if (searchFilters.dietary) {
      results = results.filter(recipe => 
        recipe.dietary === searchFilters.dietary ||
        (recipe.tags && recipe.tags.includes(searchFilters.dietary))
      );
    }
    
    setFilteredRecipes(results);
    setLoading(false);
  };

  const handleCategoryClick = (categoryId) => {
    setActiveCategory(categoryId);
    setLoading(true);
    
    if (categoryId === 'all') {
      setFilteredRecipes(recipes);
    } else {
      const filtered = recipes.filter(recipe => 
        recipe.category === categoryId || 
        (recipe.tags && recipe.tags.includes(categoryId))
      );
      setFilteredRecipes(filtered);
    }
    
    setLoading(false);
  };

  return (
    <div className="recipes-page">
      <div className="container">
        <div className="row mb-4">
          <div className="col">
            <h1 className="page-title">Discover Recipes</h1>
            <p className="text-muted">Find the perfect recipe for any meal or occasion.</p>
          </div>
        </div>
        
        <div className="row mb-4">
          <div className="col">
            <SearchBar onSearch={handleSearch} />
          </div>
        </div>
        
        {/* Category Tabs */}
        <div className="row mb-4">
          <div className="col">
            <div className="category-tabs">
              <ul className="nav nav-pills category-nav">
                {categories.map(category => (
                  <li className="nav-item" key={category.id}>
                    <button
                      className={`nav-link ${activeCategory === category.id ? 'active bg-success' : ''}`}
                      onClick={() => handleCategoryClick(category.id)}
                    >
                      {category.name}
                    </button>
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </div>
        
        {/* Recipe Results */}
        <div className="row">
          {loading ? (
            <div className="col text-center py-5">
              <div className="spinner-border text-success" role="status">
                <span className="visually-hidden">Loading...</span>
              </div>
            </div>
          ) : filteredRecipes.length > 0 ? (
            <>
              <div className="col-12 mb-3">
                <p className="text-muted">{filteredRecipes.length} recipes found</p>
              </div>
              {filteredRecipes.map(recipe => (
                <div className="col-12 col-sm-6 col-lg-4 col-xl-3 mb-4" key={recipe.id}>
                  <RecipeCard recipe={recipe} />
                </div>
              ))}
            </>
          ) : (
            <div className="col text-center py-5">
              <div className="no-results">
                <i className="fas fa-search mb-3" style={{ fontSize: '3rem', color: '#adb5bd' }}></i>
                <h3>No recipes found</h3>
                <p className="text-muted">Try adjusting your search or filter criteria</p>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default Recipes;
