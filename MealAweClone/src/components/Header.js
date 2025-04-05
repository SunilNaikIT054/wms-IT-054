import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { useAppContext } from '../context/AppContext';

const Header = () => {
  const { user } = useAppContext();
  const [isNavOpen, setIsNavOpen] = useState(false);

  const toggleNav = () => {
    setIsNavOpen(!isNavOpen);
  };

  return (
    <header className="navbar navbar-expand-lg navbar-light bg-white py-3 shadow-sm">
      <div className="container">
        <Link className="navbar-brand d-flex align-items-center" to="/">
          <span className="text-success fw-bold fs-4">MealAwe</span>
        </Link>
        
        <button 
          className="navbar-toggler" 
          type="button" 
          onClick={toggleNav}
        >
          <span className="navbar-toggler-icon"></span>
        </button>
        
        <div className={`collapse navbar-collapse ${isNavOpen ? 'show' : ''}`}>
          <ul className="navbar-nav ms-auto mb-2 mb-lg-0">
            <li className="nav-item">
              <Link className="nav-link" to="/">Home</Link>
            </li>
            <li className="nav-item">
              <Link className="nav-link" to="/recipes">Recipes</Link>
            </li>
            <li className="nav-item">
              <Link className="nav-link" to="/meal-planner">Meal Planner</Link>
            </li>
            <li className="nav-item">
              <Link className="nav-link" to="/grocery-list">Grocery List</Link>
            </li>
            {user ? (
              <li className="nav-item">
                <Link className="nav-link" to="/profile">
                  <i className="fas fa-user-circle me-1"></i>
                  {user.name}
                </Link>
              </li>
            ) : (
              <li className="nav-item">
                <button className="btn btn-success ms-lg-3">Sign In</button>
              </li>
            )}
          </ul>
        </div>
      </div>
    </header>
  );
};

export default Header;
