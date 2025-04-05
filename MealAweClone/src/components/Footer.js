import React from 'react';
import { Link } from 'react-router-dom';

const Footer = () => {
  const currentYear = new Date().getFullYear();
  
  return (
    <footer className="bg-dark text-light py-5">
      <div className="container">
        <div className="row">
          <div className="col-md-4 mb-4 mb-md-0">
            <h5 className="text-uppercase mb-4">MealAwe</h5>
            <p className="mb-3">Simplify your meal planning journey with our easy-to-use tools for finding recipes, planning meals, and creating grocery lists.</p>
            <div className="social-icons">
              <a href="#!" className="me-3 text-light">
                <i className="fab fa-facebook-f"></i>
              </a>
              <a href="#!" className="me-3 text-light">
                <i className="fab fa-twitter"></i>
              </a>
              <a href="#!" className="me-3 text-light">
                <i className="fab fa-instagram"></i>
              </a>
              <a href="#!" className="text-light">
                <i className="fab fa-pinterest"></i>
              </a>
            </div>
          </div>
          
          <div className="col-md-2 mb-4 mb-md-0">
            <h5 className="text-uppercase mb-4">Quick Links</h5>
            <ul className="list-unstyled">
              <li className="mb-2">
                <Link to="/" className="text-light text-decoration-none">Home</Link>
              </li>
              <li className="mb-2">
                <Link to="/recipes" className="text-light text-decoration-none">Recipes</Link>
              </li>
              <li className="mb-2">
                <Link to="/meal-planner" className="text-light text-decoration-none">Meal Planner</Link>
              </li>
              <li className="mb-2">
                <Link to="/grocery-list" className="text-light text-decoration-none">Grocery List</Link>
              </li>
            </ul>
          </div>
          
          <div className="col-md-3 mb-4 mb-md-0">
            <h5 className="text-uppercase mb-4">Categories</h5>
            <ul className="list-unstyled">
              <li className="mb-2">
                <Link to="/recipes?category=breakfast" className="text-light text-decoration-none">Breakfast</Link>
              </li>
              <li className="mb-2">
                <Link to="/recipes?category=lunch" className="text-light text-decoration-none">Lunch</Link>
              </li>
              <li className="mb-2">
                <Link to="/recipes?category=dinner" className="text-light text-decoration-none">Dinner</Link>
              </li>
              <li className="mb-2">
                <Link to="/recipes?category=desserts" className="text-light text-decoration-none">Desserts</Link>
              </li>
              <li className="mb-2">
                <Link to="/recipes?category=vegetarian" className="text-light text-decoration-none">Vegetarian</Link>
              </li>
            </ul>
          </div>
          
          <div className="col-md-3">
            <h5 className="text-uppercase mb-4">Newsletter</h5>
            <p className="mb-3">Subscribe to our newsletter for the latest recipes and meal plans</p>
            <div className="input-group">
              <input
                type="email"
                className="form-control"
                placeholder="Your email"
                aria-label="Your email"
              />
              <button className="btn btn-success" type="button">
                Subscribe
              </button>
            </div>
          </div>
        </div>
        
        <hr className="my-4 bg-light" />
        
        <div className="row">
          <div className="col-md-6 mb-3 mb-md-0">
            <p className="mb-0">© {currentYear} MealAwe. All rights reserved.</p>
          </div>
          <div className="col-md-6 text-md-end">
            <a href="#!" className="text-light text-decoration-none me-3">Privacy Policy</a>
            <a href="#!" className="text-light text-decoration-none me-3">Terms of Service</a>
            <a href="#!" className="text-light text-decoration-none">Contact</a>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
