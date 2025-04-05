import React from 'react';

const MealPlanCard = ({ day, date, meals, onEditMeal, onRemoveMeal }) => {
  // Format the date to show day name and date
  const formatDate = (dateString) => {
    const options = { weekday: 'long', month: 'short', day: 'numeric' };
    return new Date(dateString).toLocaleDateString('en-US', options);
  };

  return (
    <div className="card mb-4">
      <div className="card-header bg-success text-white">
        <h5 className="mb-0">{formatDate(date)}</h5>
      </div>
      <div className="card-body">
        {['breakfast', 'lunch', 'dinner', 'snacks'].map(mealType => (
          <div key={mealType} className="mb-3">
            <div className="d-flex justify-content-between align-items-center mb-2">
              <h6 className="text-capitalize mb-0">{mealType}</h6>
              <button 
                className="btn btn-sm btn-outline-success" 
                onClick={() => onEditMeal(date, mealType)}
              >
                <i className="fas fa-plus me-1"></i> Add
              </button>
            </div>
            
            {meals && meals[mealType] && meals[mealType].length > 0 ? (
              <div className="list-group">
                {meals[mealType].map(meal => (
                  <div 
                    key={meal.id} 
                    className="list-group-item list-group-item-action d-flex justify-content-between align-items-center"
                  >
                    <div className="d-flex align-items-center">
                      {meal.image && (
                        <img 
                          src={meal.image} 
                          alt={meal.title} 
                          className="rounded me-3"
                          style={{ width: '40px', height: '40px', objectFit: 'cover' }}
                        />
                      )}
                      <div>
                        <h6 className="mb-0">{meal.title}</h6>
                        <small className="text-muted">{meal.servings} servings</small>
                      </div>
                    </div>
                    <button 
                      className="btn btn-sm text-danger" 
                      onClick={() => onRemoveMeal(date, mealType, meal.id)}
                    >
                      <i className="fas fa-times"></i>
                    </button>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center text-muted py-3 border rounded">
                <i className="fas fa-utensils mb-2" style={{ fontSize: '1.5rem' }}></i>
                <p className="mb-0">No meals planned</p>
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
};

export default MealPlanCard;
