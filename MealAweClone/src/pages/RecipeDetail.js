import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useAppContext } from '../context/AppContext';

const RecipeDetail = () => {
  const { id } = useParams();
  const { recipes, addToFavorites, removeFromFavorites, favorites, addToMealPlan } = useAppContext();
  const [recipe, setRecipe] = useState(null);
  const [loading, setLoading] = useState(true);
  const [servingSize, setServingSize] = useState(0);
  const [showAddToMealPlan, setShowAddToMealPlan] = useState(false);
  const [selectedDate, setSelectedDate] = useState('');
  const [selectedMealType, setSelectedMealType] = useState('breakfast');
  
  // Check if recipe is in favorites
  const isFavorite = favorites.some(fav => fav.id === id);
  
  useEffect(() => {
    // Find the recipe by ID
    const foundRecipe = recipes.find(r => r.id === id);
    
    if (foundRecipe) {
      setRecipe(foundRecipe);
      setServingSize(foundRecipe.servings || 2);
    }
    
    setLoading(false);
  }, [id, recipes]);
  
  const handleServingSizeChange = (increase) => {
    if (increase) {
      setServingSize(prev => prev + 1);
    } else if (servingSize > 1) {
      setServingSize(prev => prev - 1);
    }
  };
  
  const toggleFavorite = () => {
    if (isFavorite) {
      removeFromFavorites(id);
    } else if (recipe) {
      addToFavorites(recipe);
    }
  };
  
  const handleOpenMealPlanModal = () => {
    // Set default date to today
    const today = new Date().toISOString().split('T')[0];
    setSelectedDate(today);
    setShowAddToMealPlan(true);
  };
  
  const handleAddToMealPlan = () => {
    if (!selectedDate || !selectedMealType || !recipe) return;
    
    addToMealPlan(selectedDate, selectedMealType, recipe);
    setShowAddToMealPlan(false);
  };
  
  // Generate dates for the next 7 days
  const generateDateOptions = () => {
    const dates = [];
    const today = new Date();
    
    for (let i = 0; i < 7; i++) {
      const date = new Date(today);
      date.setDate(today.getDate() + i);
      const dateString = date.toISOString().split('T')[0];
      
      dates.push({
        date: dateString,
        label: date.toLocaleDateString('en-US', { weekday: 'long', month: 'short', day: 'numeric' })
      });
    }
    
    return dates;
  };
  
  if (loading) {
    return (
      <div className="text-center py-5">
        <div className="spinner-border text-success" role="status">
          <span className="visually-hidden">Loading...</span>
        </div>
      </div>
    );
  }
  
  if (!recipe) {
    return (
      <div className="container py-5 text-center">
        <h2>Recipe Not Found</h2>
        <p>Sorry, we couldn't find the recipe you're looking for.</p>
        <Link to="/recipes" className="btn btn-success">
          Browse All Recipes
        </Link>
      </div>
    );
  }
  
  // Calculate quantity multiplier based on serving size
  const servingMultiplier = recipe.servings ? servingSize / recipe.servings : 1;
  
  return (
    <div className="recipe-detail-page">
      <div className="container">
        {/* Breadcrumb */}
        <nav aria-label="breadcrumb" className="mt-3 mb-4">
          <ol className="breadcrumb">
            <li className="breadcrumb-item">
              <Link to="/">Home</Link>
            </li>
            <li className="breadcrumb-item">
              <Link to="/recipes">Recipes</Link>
            </li>
            <li className="breadcrumb-item active" aria-current="page">
              {recipe.title}
            </li>
          </ol>
        </nav>
        
        {/* Recipe Header */}
        <div className="row mb-5">
          <div className="col-lg-6 mb-4 mb-lg-0">
            <div className="position-relative">
              <img 
                src={recipe.image || "https://via.placeholder.com/600x400/f0f0f0/a0a0a0?text=No+Image"} 
                alt={recipe.title} 
                className="img-fluid rounded shadow-sm"
                style={{ width: '100%', height: '400px', objectFit: 'cover' }}
              />
              <button 
                className="btn position-absolute top-0 end-0 m-3 p-2"
                onClick={toggleFavorite}
                style={{ backgroundColor: 'white', borderRadius: '50%' }}
              >
                <i className={`fas fa-heart ${isFavorite ? 'text-danger' : 'text-secondary'}`} style={{ fontSize: '1.5rem' }}></i>
              </button>
            </div>
          </div>
          
          <div className="col-lg-6">
            <div className="py-3">
              {recipe.tags && recipe.tags.map((tag, index) => (
                <span key={index} className="badge bg-light text-dark me-2 mb-2">{tag}</span>
              ))}
              <h1 className="mt-2 mb-3">{recipe.title}</h1>
              <p className="lead mb-4">{recipe.description}</p>
              
              <div className="d-flex flex-wrap mb-4">
                <div className="me-4 mb-3">
                  <div className="text-muted small">Prep Time</div>
                  <div className="d-flex align-items-center">
                    <i className="far fa-clock me-2 text-success"></i>
                    <span>{recipe.prepTime || '-'} mins</span>
                  </div>
                </div>
                <div className="me-4 mb-3">
                  <div className="text-muted small">Cook Time</div>
                  <div className="d-flex align-items-center">
                    <i className="fas fa-fire-alt me-2 text-success"></i>
                    <span>{recipe.cookTime || '-'} mins</span>
                  </div>
                </div>
                <div className="me-4 mb-3">
                  <div className="text-muted small">Total Time</div>
                  <div className="d-flex align-items-center">
                    <i className="fas fa-hourglass-half me-2 text-success"></i>
                    <span>{(recipe.prepTime || 0) + (recipe.cookTime || 0)} mins</span>
                  </div>
                </div>
                <div className="me-4 mb-3">
                  <div className="text-muted small">Difficulty</div>
                  <div className="d-flex align-items-center">
                    <i className="fas fa-chart-line me-2 text-success"></i>
                    <span>{recipe.difficulty || 'Easy'}</span>
                  </div>
                </div>
                <div className="mb-3">
                  <div className="text-muted small">Calories</div>
                  <div className="d-flex align-items-center">
                    <i className="fas fa-fire me-2 text-success"></i>
                    <span>{recipe.calories || '-'} cal</span>
                  </div>
                </div>
              </div>
              
              <div className="d-flex align-items-center mb-4">
                <div className="me-3">
                  <div className="text-muted small">Servings</div>
                  <div className="input-group">
                    <button 
                      className="btn btn-outline-secondary" 
                      type="button"
                      onClick={() => handleServingSizeChange(false)}
                      disabled={servingSize <= 1}
                    >
                      <i className="fas fa-minus"></i>
                    </button>
                    <input 
                      type="text" 
                      className="form-control text-center" 
                      value={servingSize}
                      readOnly
                      style={{ maxWidth: '60px' }}
                    />
                    <button 
                      className="btn btn-outline-secondary" 
                      type="button"
                      onClick={() => handleServingSizeChange(true)}
                    >
                      <i className="fas fa-plus"></i>
                    </button>
                  </div>
                </div>
              </div>
              
              <div className="d-flex flex-wrap gap-2">
                <button 
                  className="btn btn-success"
                  onClick={handleOpenMealPlanModal}
                >
                  <i className="fas fa-calendar-plus me-2"></i> Add to Meal Plan
                </button>
                <button className="btn btn-outline-success">
                  <i className="fas fa-print me-2"></i> Print Recipe
                </button>
                <button className="btn btn-outline-secondary">
                  <i className="fas fa-share-alt me-2"></i> Share
                </button>
              </div>
            </div>
          </div>
        </div>
        
        {/* Recipe Content */}
        <div className="row">
          <div className="col-lg-4 mb-4 mb-lg-0">
            <div className="card shadow-sm mb-4">
              <div className="card-header bg-success text-white">
                <h4 className="mb-0">Ingredients</h4>
              </div>
              <div className="card-body">
                <ul className="list-group list-group-flush">
                  {recipe.ingredients && recipe.ingredients.map((ingredient, index) => (
                    <li key={index} className="list-group-item border-0 px-0 py-2">
                      <div className="form-check">
                        <input className="form-check-input" type="checkbox" id={`ingredient-${index}`} />
                        <label className="form-check-label" htmlFor={`ingredient-${index}`}>
                          {ingredient.quantity && (
                            <span className="fw-bold">
                              {(parseFloat(ingredient.quantity) * servingMultiplier).toFixed(
                                Number.isInteger(parseFloat(ingredient.quantity) * servingMultiplier) ? 0 : 1
                              )} {ingredient.unit}
                            </span>
                          )} {ingredient.name}
                        </label>
                      </div>
                    </li>
                  ))}
                </ul>
              </div>
            </div>
            
            <div className="card shadow-sm">
              <div className="card-header bg-success text-white">
                <h4 className="mb-0">Nutrition Facts</h4>
              </div>
              <div className="card-body">
                {recipe.nutrition ? (
                  <table className="table table-borderless">
                    <tbody>
                      {Object.entries(recipe.nutrition).map(([key, value]) => (
                        <tr key={key}>
                          <th scope="row" className="text-capitalize ps-0">{key}</th>
                          <td className="text-end pe-0">{value}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                ) : (
                  <p className="text-muted">Nutrition information not available for this recipe.</p>
                )}
              </div>
            </div>
          </div>
          
          <div className="col-lg-8">
            <div className="card shadow-sm mb-4">
              <div className="card-header bg-success text-white">
                <h4 className="mb-0">Instructions</h4>
              </div>
              <div className="card-body">
                {recipe.instructions ? (
                  <div>
                    {recipe.instructions.map((step, index) => (
                      <div key={index} className="mb-4">
                        <div className="d-flex mb-2">
                          <div className="step-number bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-3" style={{ width: '36px', height: '36px', minWidth: '36px' }}>
                            <span>{index + 1}</span>
                          </div>
                          <h5 className="mb-0">{step.title}</h5>
                        </div>
                        <p className="ms-5">{step.description}</p>
                      </div>
                    ))}
                  </div>
                ) : (
                  <p className="text-muted">Instructions not available for this recipe.</p>
                )}
              </div>
            </div>
            
            <div className="card shadow-sm">
              <div className="card-header bg-success text-white">
                <h4 className="mb-0">Notes & Tips</h4>
              </div>
              <div className="card-body">
                {recipe.notes ? (
                  <div>
                    {recipe.notes.map((note, index) => (
                      <div key={index} className="mb-3">
                        <div className="d-flex align-items-start">
                          <i className="fas fa-lightbulb text-warning me-3" style={{ marginTop: '4px' }}></i>
                          <p className="mb-0">{note}</p>
                        </div>
                      </div>
                    ))}
                  </div>
                ) : (
                  <p className="text-muted">No additional notes or tips available for this recipe.</p>
                )}
              </div>
            </div>
          </div>
        </div>
        
        {/* Add to Meal Plan Modal */}
        {showAddToMealPlan && (
          <div className="modal fade show" style={{ display: 'block' }} tabIndex="-1">
            <div className="modal-dialog modal-dialog-centered">
              <div className="modal-content">
                <div className="modal-header">
                  <h5 className="modal-title">Add to Meal Plan</h5>
                  <button 
                    type="button" 
                    className="btn-close" 
                    onClick={() => setShowAddToMealPlan(false)}
                  ></button>
                </div>
                <div className="modal-body">
                  <div className="mb-3">
                    <label htmlFor="mealPlanDate" className="form-label">Date</label>
                    <select
                      id="mealPlanDate"
                      className="form-select"
                      value={selectedDate}
                      onChange={(e) => setSelectedDate(e.target.value)}
                    >
                      {generateDateOptions().map(option => (
                        <option key={option.date} value={option.date}>
                          {option.label}
                        </option>
                      ))}
                    </select>
                  </div>
                  
                  <div className="mb-3">
                    <label htmlFor="mealType" className="form-label">Meal Type</label>
                    <select
                      id="mealType"
                      className="form-select"
                      value={selectedMealType}
                      onChange={(e) => setSelectedMealType(e.target.value)}
                    >
                      <option value="breakfast">Breakfast</option>
                      <option value="lunch">Lunch</option>
                      <option value="dinner">Dinner</option>
                      <option value="snacks">Snacks</option>
                    </select>
                  </div>
                </div>
                <div className="modal-footer">
                  <button 
                    type="button" 
                    className="btn btn-secondary" 
                    onClick={() => setShowAddToMealPlan(false)}
                  >
                    Cancel
                  </button>
                  <button 
                    type="button" 
                    className="btn btn-success"
                    onClick={handleAddToMealPlan}
                  >
                    Add to Meal Plan
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

export default RecipeDetail;
