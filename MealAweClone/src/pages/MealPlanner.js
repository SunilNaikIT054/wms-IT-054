import React, { useState, useEffect } from 'react';
import { useAppContext } from '../context/AppContext';
import MealPlanCard from '../components/MealPlanCard';
import RecipeCard from '../components/RecipeCard';

const MealPlanner = () => {
  const { recipes, mealPlans, updateMealPlan } = useAppContext();
  const [currentWeek, setCurrentWeek] = useState([]);
  const [selectedDate, setSelectedDate] = useState(null);
  const [selectedMealType, setSelectedMealType] = useState(null);
  const [showRecipeSelector, setShowRecipeSelector] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [filteredRecipes, setFilteredRecipes] = useState([]);
  
  // Generate days for the current week
  useEffect(() => {
    const today = new Date();
    const dayOfWeek = today.getDay(); // 0 = Sunday, 1 = Monday, etc.
    const days = [];
    
    // Calculate the start of the week (Sunday)
    const startDate = new Date(today);
    startDate.setDate(today.getDate() - dayOfWeek);
    
    // Generate 7 days starting from Sunday
    for (let i = 0; i < 7; i++) {
      const date = new Date(startDate);
      date.setDate(startDate.getDate() + i);
      days.push({
        date: date.toISOString().split('T')[0], // Format as YYYY-MM-DD
        dayOfWeek: i,
      });
    }
    
    setCurrentWeek(days);
  }, []);
  
  // Update filtered recipes when search term changes
  useEffect(() => {
    if (searchTerm.trim() === '') {
      setFilteredRecipes(recipes);
    } else {
      const term = searchTerm.toLowerCase();
      const filtered = recipes.filter(recipe => 
        recipe.title.toLowerCase().includes(term) || 
        (recipe.description && recipe.description.toLowerCase().includes(term))
      );
      setFilteredRecipes(filtered);
    }
  }, [searchTerm, recipes]);
  
  const handleEditMeal = (date, mealType) => {
    setSelectedDate(date);
    setSelectedMealType(mealType);
    setShowRecipeSelector(true);
    // Reset search term when opening the selector
    setSearchTerm('');
    setFilteredRecipes(recipes);
  };
  
  const handleRemoveMeal = (date, mealType, recipeId) => {
    const updatedMealPlan = { ...mealPlans[date] };
    
    if (updatedMealPlan && updatedMealPlan[mealType]) {
      updatedMealPlan[mealType] = updatedMealPlan[mealType].filter(meal => meal.id !== recipeId);
      updateMealPlan(date, updatedMealPlan);
    }
  };
  
  const handleAddToMealPlan = (recipe) => {
    if (!selectedDate || !selectedMealType) return;
    
    const currentPlan = mealPlans[selectedDate] || {};
    const currentMeals = currentPlan[selectedMealType] || [];
    
    // Check if recipe is already in the meal plan
    const isAlreadyAdded = currentMeals.some(meal => meal.id === recipe.id);
    
    if (!isAlreadyAdded) {
      const updatedMeals = [...currentMeals, recipe];
      const updatedMealPlan = {
        ...currentPlan,
        [selectedMealType]: updatedMeals
      };
      
      updateMealPlan(selectedDate, updatedMealPlan);
    }
    
    // Close the recipe selector
    setShowRecipeSelector(false);
    setSelectedDate(null);
    setSelectedMealType(null);
  };
  
  const handleNextWeek = () => {
    const nextWeek = currentWeek.map(day => {
      const date = new Date(day.date);
      date.setDate(date.getDate() + 7);
      return {
        ...day,
        date: date.toISOString().split('T')[0]
      };
    });
    setCurrentWeek(nextWeek);
  };
  
  const handlePrevWeek = () => {
    const prevWeek = currentWeek.map(day => {
      const date = new Date(day.date);
      date.setDate(date.getDate() - 7);
      return {
        ...day,
        date: date.toISOString().split('T')[0]
      };
    });
    setCurrentWeek(prevWeek);
  };
  
  const formatWeekRange = () => {
    if (currentWeek.length === 0) return '';
    
    const firstDay = new Date(currentWeek[0].date);
    const lastDay = new Date(currentWeek[6].date);
    
    const options = { month: 'short', day: 'numeric' };
    return `${firstDay.toLocaleDateString('en-US', options)} - ${lastDay.toLocaleDateString('en-US', options)}`;
  };
  
  return (
    <div className="meal-planner-page">
      <div className="container">
        <div className="row mb-4">
          <div className="col">
            <h1 className="page-title">Meal Planner</h1>
            <p className="text-muted">Plan your meals for the week ahead.</p>
          </div>
        </div>
        
        {/* Week Selector */}
        <div className="row mb-4">
          <div className="col">
            <div className="card">
              <div className="card-body d-flex justify-content-between align-items-center">
                <button 
                  className="btn btn-outline-secondary" 
                  onClick={handlePrevWeek}
                >
                  <i className="fas fa-chevron-left me-1"></i> Previous Week
                </button>
                
                <h5 className="mb-0">{formatWeekRange()}</h5>
                
                <button 
                  className="btn btn-outline-secondary" 
                  onClick={handleNextWeek}
                >
                  Next Week <i className="fas fa-chevron-right ms-1"></i>
                </button>
              </div>
            </div>
          </div>
        </div>
        
        {/* Meal Plan Cards */}
        <div className="row">
          {currentWeek.map(day => (
            <div className="col-12 col-md-6 col-lg-4" key={day.date}>
              <MealPlanCard
                day={day.dayOfWeek}
                date={day.date}
                meals={mealPlans[day.date]}
                onEditMeal={handleEditMeal}
                onRemoveMeal={handleRemoveMeal}
              />
            </div>
          ))}
        </div>
        
        {/* Recipe Selector Modal */}
        {showRecipeSelector && (
          <div className="modal fade show" style={{ display: 'block' }} tabIndex="-1">
            <div className="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-xl">
              <div className="modal-content">
                <div className="modal-header">
                  <h5 className="modal-title">
                    Add Recipe to {new Date(selectedDate).toLocaleDateString('en-US', { weekday: 'long' })} - {selectedMealType}
                  </h5>
                  <button 
                    type="button" 
                    className="btn-close" 
                    onClick={() => setShowRecipeSelector(false)}
                  ></button>
                </div>
                <div className="modal-body">
                  <div className="mb-3">
                    <input
                      type="text"
                      className="form-control"
                      placeholder="Search recipes..."
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                    />
                  </div>
                  <div className="row g-3">
                    {filteredRecipes.length > 0 ? (
                      filteredRecipes.map(recipe => (
                        <div className="col-12 col-md-6 col-lg-4" key={recipe.id}>
                          <div className="card h-100">
                            <div className="card-body">
                              <h5 className="card-title">{recipe.title}</h5>
                              <p className="card-text small">
                                {recipe.description && recipe.description.length > 100 
                                  ? `${recipe.description.substring(0, 100)}...` 
                                  : recipe.description}
                              </p>
                              <div className="d-flex align-items-center mb-2">
                                <i className="far fa-clock text-muted me-1"></i>
                                <small className="text-muted">{recipe.cookTime} mins</small>
                                <i className="fas fa-utensils text-muted ms-3 me-1"></i>
                                <small className="text-muted">{recipe.servings} servings</small>
                              </div>
                              <button 
                                className="btn btn-success w-100"
                                onClick={() => handleAddToMealPlan(recipe)}
                              >
                                Add to Meal Plan
                              </button>
                            </div>
                          </div>
                        </div>
                      ))
                    ) : (
                      <div className="col-12 text-center py-4">
                        <p>No recipes found. Try a different search term.</p>
                      </div>
                    )}
                  </div>
                </div>
                <div className="modal-footer">
                  <button 
                    type="button" 
                    className="btn btn-secondary" 
                    onClick={() => setShowRecipeSelector(false)}
                  >
                    Cancel
                  </button>
                </div>
              </div>
            </div>
            <div className="modal-backdrop fade show"></div>
          </div>
        )}
      </div>
    </div>
  );
};

export default MealPlanner;
