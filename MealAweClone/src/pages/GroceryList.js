import React, { useState, useEffect } from 'react';
import { useAppContext } from '../context/AppContext';

const GroceryList = () => {
  const { mealPlans, recipes } = useAppContext();
  const [groceryItems, setGroceryItems] = useState([]);
  const [selectedDates, setSelectedDates] = useState([]);
  const [isGenerating, setIsGenerating] = useState(false);
  const [checkItems, setCheckItems] = useState({});
  
  // Generate dates for the next 2 weeks
  const generateDateOptions = () => {
    const dates = [];
    const today = new Date();
    
    for (let i = 0; i < 14; i++) {
      const date = new Date(today);
      date.setDate(today.getDate() + i);
      const dateString = date.toISOString().split('T')[0];
      
      dates.push({
        date: dateString,
        label: date.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' })
      });
    }
    
    return dates;
  };
  
  const dateOptions = generateDateOptions();
  
  const generateGroceryList = () => {
    if (selectedDates.length === 0) return;
    
    setIsGenerating(true);
    
    // Get all meal plans for selected dates
    const selectedPlans = {};
    selectedDates.forEach(date => {
      if (mealPlans[date]) {
        selectedPlans[date] = mealPlans[date];
      }
    });
    
    // Extract all recipes from the meal plans
    const mealRecipes = [];
    Object.values(selectedPlans).forEach(plan => {
      ['breakfast', 'lunch', 'dinner', 'snacks'].forEach(mealType => {
        if (plan[mealType]) {
          mealRecipes.push(...plan[mealType]);
        }
      });
    });
    
    // Get all ingredients from the recipes and organize by category
    const ingredientsByCategory = {};
    
    mealRecipes.forEach(mealRecipe => {
      // Find the full recipe details
      const fullRecipe = recipes.find(r => r.id === mealRecipe.id);
      
      if (fullRecipe && fullRecipe.ingredients) {
        fullRecipe.ingredients.forEach(ingredient => {
          const category = ingredient.category || 'Other';
          
          if (!ingredientsByCategory[category]) {
            ingredientsByCategory[category] = [];
          }
          
          // Check if ingredient already exists in the list
          const existingItem = ingredientsByCategory[category].find(
            item => item.name.toLowerCase() === ingredient.name.toLowerCase()
          );
          
          if (existingItem) {
            // Update quantity if needed
            if (ingredient.quantity) {
              existingItem.quantity = (parseFloat(existingItem.quantity) + parseFloat(ingredient.quantity)).toString();
            }
          } else {
            // Add new ingredient
            ingredientsByCategory[category].push({
              ...ingredient,
              id: `${category}-${ingredient.name}`.replace(/\s+/g, '-').toLowerCase()
            });
          }
        });
      }
    });
    
    // Initialize check state for all items
    const newCheckItems = {};
    Object.values(ingredientsByCategory).flat().forEach(item => {
      newCheckItems[item.id] = false;
    });
    setCheckItems(newCheckItems);
    
    setGroceryItems(ingredientsByCategory);
    setIsGenerating(false);
  };
  
  const handleDateToggle = (date) => {
    setSelectedDates(prev => {
      if (prev.includes(date)) {
        return prev.filter(d => d !== date);
      } else {
        return [...prev, date];
      }
    });
  };
  
  const handleCheckItem = (itemId) => {
    setCheckItems(prev => ({
      ...prev,
      [itemId]: !prev[itemId]
    }));
  };
  
  const handleSelectAll = (category) => {
    const updatedCheckItems = { ...checkItems };
    const categoryItems = groceryItems[category];
    
    categoryItems.forEach(item => {
      updatedCheckItems[item.id] = true;
    });
    
    setCheckItems(updatedCheckItems);
  };
  
  const handleUnselectAll = (category) => {
    const updatedCheckItems = { ...checkItems };
    const categoryItems = groceryItems[category];
    
    categoryItems.forEach(item => {
      updatedCheckItems[item.id] = false;
    });
    
    setCheckItems(updatedCheckItems);
  };
  
  const countCheckedItems = (category) => {
    if (!groceryItems[category]) return 0;
    
    return groceryItems[category].filter(item => checkItems[item.id]).length;
  };
  
  const getTotalItems = (category) => {
    if (!groceryItems[category]) return 0;
    return groceryItems[category].length;
  };
  
  const handlePrint = () => {
    window.print();
  };
  
  const getCategoryIcon = (category) => {
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
  
  return (
    <div className="grocery-list-page">
      <div className="container">
        <div className="row mb-4">
          <div className="col">
            <h1 className="page-title">Grocery List</h1>
            <p className="text-muted">Generate a shopping list based on your meal plan.</p>
          </div>
        </div>
        
        <div className="row">
          <div className="col-lg-4 mb-4">
            <div className="card">
              <div className="card-header bg-success text-white">
                <h5 className="mb-0">Select Dates for Your List</h5>
              </div>
              <div className="card-body">
                <p className="text-muted mb-3">Choose dates from your meal plan to include in your grocery list.</p>
                
                <div className="date-options mb-4">
                  {dateOptions.map(option => (
                    <div className="form-check" key={option.date}>
                      <input
                        className="form-check-input"
                        type="checkbox"
                        id={`date-${option.date}`}
                        checked={selectedDates.includes(option.date)}
                        onChange={() => handleDateToggle(option.date)}
                      />
                      <label className="form-check-label" htmlFor={`date-${option.date}`}>
                        {option.label}
                        {mealPlans[option.date] ? (
                          <span className="badge bg-success ms-2 rounded-pill">
                            <i className="fas fa-check me-1"></i> Planned
                          </span>
                        ) : (
                          <span className="badge bg-light text-dark ms-2 rounded-pill">No plan</span>
                        )}
                      </label>
                    </div>
                  ))}
                </div>
                
                <button
                  className="btn btn-success w-100"
                  onClick={generateGroceryList}
                  disabled={selectedDates.length === 0 || isGenerating}
                >
                  {isGenerating ? (
                    <>
                      <span className="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                      Generating...
                    </>
                  ) : (
                    <>
                      <i className="fas fa-shopping-basket me-2"></i> Generate Grocery List
                    </>
                  )}
                </button>
              </div>
            </div>
          </div>
          
          <div className="col-lg-8">
            {Object.keys(groceryItems).length > 0 ? (
              <div className="grocery-list">
                <div className="d-flex justify-content-between align-items-center mb-3">
                  <h4>Your Grocery List</h4>
                  <button className="btn btn-outline-secondary" onClick={handlePrint}>
                    <i className="fas fa-print me-2"></i> Print List
                  </button>
                </div>
                
                <div className="accordion" id="groceryAccordion">
                  {Object.keys(groceryItems).map(category => (
                    <div className="accordion-item" key={category}>
                      <h2 className="accordion-header" id={`heading-${category}`}>
                        <button
                          className="accordion-button"
                          type="button"
                          data-bs-toggle="collapse"
                          data-bs-target={`#collapse-${category}`}
                          aria-expanded="true"
                          aria-controls={`collapse-${category}`}
                        >
                          <i className={`fas ${getCategoryIcon(category)} me-2`}></i>
                          <span>{category}</span>
                          <span className="badge bg-success ms-2">
                            {countCheckedItems(category)}/{getTotalItems(category)}
                          </span>
                        </button>
                      </h2>
                      <div
                        id={`collapse-${category}`}
                        className="accordion-collapse collapse show"
                        aria-labelledby={`heading-${category}`}
                      >
                        <div className="accordion-body">
                          <div className="d-flex justify-content-end mb-2">
                            <button
                              className="btn btn-sm btn-outline-success me-2"
                              onClick={() => handleSelectAll(category)}
                            >
                              Select All
                            </button>
                            <button
                              className="btn btn-sm btn-outline-secondary"
                              onClick={() => handleUnselectAll(category)}
                            >
                              Unselect All
                            </button>
                          </div>
                          
                          <ul className="list-group">
                            {groceryItems[category].map(item => (
                              <li
                                key={item.id}
                                className={`list-group-item d-flex justify-content-between align-items-center ${
                                  checkItems[item.id] ? 'text-decoration-line-through text-muted' : ''
                                }`}
                              >
                                <div className="form-check">
                                  <input
                                    className="form-check-input"
                                    type="checkbox"
                                    id={item.id}
                                    checked={checkItems[item.id]}
                                    onChange={() => handleCheckItem(item.id)}
                                  />
                                  <label className="form-check-label" htmlFor={item.id}>
                                    {item.name}
                                  </label>
                                </div>
                                {item.quantity && (
                                  <span className="badge bg-light text-dark">
                                    {item.quantity} {item.unit}
                                  </span>
                                )}
                              </li>
                            ))}
                          </ul>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            ) : (
              <div className="card">
                <div className="card-body text-center py-5">
                  <i className="fas fa-shopping-basket mb-3" style={{ fontSize: '3rem', color: '#adb5bd' }}></i>
                  <h3>No Grocery List Generated</h3>
                  <p className="text-muted">Select dates from your meal plan and click 'Generate Grocery List'.</p>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default GroceryList;
