import React from 'react';
import { Link } from 'react-router-dom';
import { useAppContext } from '../context/AppContext';

const RecipeCard = ({ recipe }) => {
  const { addToFavorites, removeFromFavorites, favorites } = useAppContext();
  const isFavorite = favorites.some(fav => fav.id === recipe.id);
  
  const toggleFavorite = (e) => {
    e.preventDefault();
    e.stopPropagation();
    
    if (isFavorite) {
      removeFromFavorites(recipe.id);
    } else {
      addToFavorites(recipe);
    }
  };
  
  // Default image if none provided
  const defaultImage = "https://via.placeholder.com/300x200/f0f0f0/a0a0a0?text=No+Image";
  
  return (
    <div className="card h-100">
      <div className="position-relative">
        <img 
          src={recipe.image || defaultImage}
          alt={recipe.title}
          className="card-img-top"
          style={{ height: '180px', objectFit: 'cover' }}
        />
        <button 
          className="btn position-absolute top-0 end-0 m-2 p-1"
          onClick={toggleFavorite}
          style={{ backgroundColor: 'white', borderRadius: '50%', width: '36px', height: '36px' }}
        >
          <i className={`fas fa-heart ${isFavorite ? 'text-danger' : 'text-secondary'}`}></i>
        </button>
      </div>
      
      <div className="card-body d-flex flex-column">
        <h5 className="card-title">{recipe.title}</h5>
        
        <div className="mb-2">
          {recipe.tags && recipe.tags.map((tag, index) => (
            <span 
              key={index} 
              className="badge bg-light text-dark me-1 mb-1"
              style={{ fontSize: '0.7rem' }}
            >
              {tag}
            </span>
          ))}
        </div>
        
        <div className="d-flex justify-content-between align-items-center mb-2">
          <div className="d-flex align-items-center">
            <i className="far fa-clock text-muted me-1"></i>
            <small className="text-muted">{recipe.cookTime} mins</small>
          </div>
          
          <div className="d-flex align-items-center">
            <i className="fas fa-fire-alt text-muted me-1"></i>
            <small className="text-muted">{recipe.calories} cal</small>
          </div>
          
          <div className="d-flex align-items-center">
            <i className="fas fa-utensils text-muted me-1"></i>
            <small className="text-muted">{recipe.servings} servings</small>
          </div>
        </div>
        
        <p className="card-text text-muted small mb-3">
          {recipe.description && recipe.description.length > 80 
            ? `${recipe.description.substring(0, 80)}...` 
            : recipe.description}
        </p>
        
        <Link 
          to={`/recipes/${recipe.id}`} 
          className="btn btn-outline-success mt-auto"
        >
          View Recipe
        </Link>
      </div>
    </div>
  );
};

export default RecipeCard;
