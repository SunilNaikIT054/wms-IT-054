import React from 'react';
import { Link } from 'react-router-dom';
import RecipeCard from '../components/RecipeCard';
import { useAppContext } from '../context/AppContext';

const Home = () => {
  const { featuredRecipes, popularRecipes } = useAppContext();
  
  return (
    <div className="home-page">
      {/* Hero Section */}
      <section className="hero-section text-center bg-light py-5 mb-5 rounded">
        <div className="container">
          <div className="row align-items-center">
            <div className="col-lg-6 text-lg-start mb-4 mb-lg-0">
              <h1 className="display-4 fw-bold mb-3">Meal Planning Made Simple</h1>
              <p className="lead mb-4">Discover recipes, create meal plans, and generate grocery lists with ease.</p>
              <div className="d-flex flex-wrap gap-2 justify-content-lg-start justify-content-center">
                <Link to="/recipes" className="btn btn-success btn-lg px-4 py-2">
                  Explore Recipes
                </Link>
                <Link to="/meal-planner" className="btn btn-outline-success btn-lg px-4 py-2">
                  Plan Your Meals
                </Link>
              </div>
            </div>
            <div className="col-lg-6">
              <div className="row g-3">
                <div className="col-6">
                  <img 
                    src="https://source.unsplash.com/random/300x200/?healthy-food" 
                    alt="Healthy food" 
                    className="img-fluid rounded"
                  />
                </div>
                <div className="col-6">
                  <img 
                    src="https://source.unsplash.com/random/300x200/?cooking" 
                    alt="Cooking" 
                    className="img-fluid rounded"
                  />
                </div>
                <div className="col-6">
                  <img 
                    src="https://source.unsplash.com/random/300x200/?meal-prep" 
                    alt="Meal prep" 
                    className="img-fluid rounded"
                  />
                </div>
                <div className="col-6">
                  <img 
                    src="https://source.unsplash.com/random/300x200/?vegetables" 
                    alt="Vegetables" 
                    className="img-fluid rounded"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* How It Works Section */}
      <section className="how-it-works-section mb-5">
        <div className="container">
          <h2 className="section-title text-center mb-4">How It Works</h2>
          <div className="row g-4">
            <div className="col-md-4">
              <div className="card h-100 border-0 shadow-sm">
                <div className="card-body text-center p-4">
                  <div className="feature-icon bg-success text-white rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style={{ width: '60px', height: '60px' }}>
                    <i className="fas fa-search fa-2x"></i>
                  </div>
                  <h5 className="card-title">Discover Recipes</h5>
                  <p className="card-text">Browse our collection of recipes or search by ingredients, dietary preferences, and more.</p>
                </div>
              </div>
            </div>
            <div className="col-md-4">
              <div className="card h-100 border-0 shadow-sm">
                <div className="card-body text-center p-4">
                  <div className="feature-icon bg-success text-white rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style={{ width: '60px', height: '60px' }}>
                    <i className="fas fa-calendar-alt fa-2x"></i>
                  </div>
                  <h5 className="card-title">Plan Your Meals</h5>
                  <p className="card-text">Drag and drop recipes into your weekly meal plan. Customize as needed.</p>
                </div>
              </div>
            </div>
            <div className="col-md-4">
              <div className="card h-100 border-0 shadow-sm">
                <div className="card-body text-center p-4">
                  <div className="feature-icon bg-success text-white rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style={{ width: '60px', height: '60px' }}>
                    <i className="fas fa-shopping-basket fa-2x"></i>
                  </div>
                  <h5 className="card-title">Generate Grocery Lists</h5>
                  <p className="card-text">We'll create a grocery list based on your meal plan, organized by store sections.</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Featured Recipes Section */}
      <section className="featured-recipes-section mb-5">
        <div className="container">
          <div className="d-flex justify-content-between align-items-center mb-4">
            <h2 className="section-title mb-0">Featured Recipes</h2>
            <Link to="/recipes" className="btn btn-outline-success">View All</Link>
          </div>
          <div className="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
            {featuredRecipes.slice(0, 4).map(recipe => (
              <div className="col" key={recipe.id}>
                <RecipeCard recipe={recipe} />
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Categories Section */}
      <section className="categories-section mb-5">
        <div className="container">
          <h2 className="section-title text-center mb-4">Browse by Category</h2>
          <div className="row g-4">
            {[
              { name: 'Breakfast', icon: 'fa-coffee', color: '#FF9800', image: 'https://source.unsplash.com/random/300x200/?breakfast' },
              { name: 'Lunch', icon: 'fa-hamburger', color: '#4CAF50', image: 'https://source.unsplash.com/random/300x200/?lunch' },
              { name: 'Dinner', icon: 'fa-utensils', color: '#2196F3', image: 'https://source.unsplash.com/random/300x200/?dinner' },
              { name: 'Desserts', icon: 'fa-ice-cream', color: '#E91E63', image: 'https://source.unsplash.com/random/300x200/?dessert' },
              { name: 'Vegetarian', icon: 'fa-seedling', color: '#4CAF50', image: 'https://source.unsplash.com/random/300x200/?vegetarian' },
              { name: 'Quick & Easy', icon: 'fa-clock', color: '#FF5722', image: 'https://source.unsplash.com/random/300x200/?quick-meal' }
            ].map((category, index) => (
              <div className="col-6 col-md-4 col-lg-2" key={index}>
                <Link to={`/recipes?category=${category.name.toLowerCase()}`} className="text-decoration-none">
                  <div className="card h-100 category-card border-0 shadow-sm overflow-hidden">
                    <div className="position-relative">
                      <img src={category.image} alt={category.name} className="card-img" style={{ height: '120px', objectFit: 'cover' }} />
                      <div className="position-absolute top-0 left-0 w-100 h-100 bg-dark" style={{ opacity: '0.4' }}></div>
                      <div className="position-absolute top-0 left-0 w-100 h-100 d-flex flex-column justify-content-center align-items-center text-white">
                        <i className={`fas ${category.icon} mb-2`} style={{ fontSize: '2rem' }}></i>
                        <h6 className="mb-0">{category.name}</h6>
                      </div>
                    </div>
                  </div>
                </Link>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Popular Recipes Section */}
      <section className="popular-recipes-section mb-5">
        <div className="container">
          <div className="d-flex justify-content-between align-items-center mb-4">
            <h2 className="section-title mb-0">Popular This Week</h2>
            <Link to="/recipes?sort=popular" className="btn btn-outline-success">View All</Link>
          </div>
          <div className="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
            {popularRecipes.slice(0, 4).map(recipe => (
              <div className="col" key={recipe.id}>
                <RecipeCard recipe={recipe} />
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Testimonials Section */}
      <section className="testimonials-section py-5 bg-light rounded mb-5">
        <div className="container">
          <h2 className="section-title text-center mb-5">What Our Users Say</h2>
          <div className="row">
            <div className="col-lg-4 mb-4 mb-lg-0">
              <div className="card h-100 border-0 shadow-sm">
                <div className="card-body p-4">
                  <div className="d-flex align-items-center mb-3">
                    <div className="text-warning me-2">
                      <i className="fas fa-star"></i>
                      <i className="fas fa-star"></i>
                      <i className="fas fa-star"></i>
                      <i className="fas fa-star"></i>
                      <i className="fas fa-star"></i>
                    </div>
                    <span className="text-muted small">5.0</span>
                  </div>
                  <p className="card-text mb-4">"This app has completely transformed my meal planning routine. I save so much time and money on groceries now!"</p>
                  <div className="d-flex align-items-center">
                    <div className="rounded-circle bg-success text-white d-flex align-items-center justify-content-center me-3" style={{ width: '50px', height: '50px' }}>
                      <span className="fw-bold">SJ</span>
                    </div>
                    <div>
                      <h6 className="mb-0">Sarah Johnson</h6>
                      <small className="text-muted">Busy Mom of 3</small>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-lg-4 mb-4 mb-lg-0">
              <div className="card h-100 border-0 shadow-sm">
                <div className="card-body p-4">
                  <div className="d-flex align-items-center mb-3">
                    <div className="text-warning me-2">
                      <i className="fas fa-star"></i>
                      <i className="fas fa-star"></i>
                      <i className="fas fa-star"></i>
                      <i className="fas fa-star"></i>
                      <i className="fas fa-star"></i>
                    </div>
                    <span className="text-muted small">5.0</span>
                  </div>
                  <p className="card-text mb-4">"As someone trying to eat healthier, this app has been a game changer. The recipe variety is impressive!"</p>
                  <div className="d-flex align-items-center">
                    <div className="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center me-3" style={{ width: '50px', height: '50px' }}>
                      <span className="fw-bold">MT</span>
                    </div>
                    <div>
                      <h6 className="mb-0">Michael Thompson</h6>
                      <small className="text-muted">Fitness Enthusiast</small>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-lg-4">
              <div className="card h-100 border-0 shadow-sm">
                <div className="card-body p-4">
                  <div className="d-flex align-items-center mb-3">
                    <div className="text-warning me-2">
                      <i className="fas fa-star"></i>
                      <i className="fas fa-star"></i>
                      <i className="fas fa-star"></i>
                      <i className="fas fa-star"></i>
                      <i className="fas fa-star-half-alt"></i>
                    </div>
                    <span className="text-muted small">4.5</span>
                  </div>
                  <p className="card-text mb-4">"I've never been good at planning meals but this app makes it so easy. The grocery list feature is a life saver!"</p>
                  <div className="d-flex align-items-center">
                    <div className="rounded-circle bg-danger text-white d-flex align-items-center justify-content-center me-3" style={{ width: '50px', height: '50px' }}>
                      <span className="fw-bold">EL</span>
                    </div>
                    <div>
                      <h6 className="mb-0">Emily Lee</h6>
                      <small className="text-muted">Graduate Student</small>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="cta-section text-center py-5 mb-5 bg-success text-white rounded">
        <div className="container">
          <h2 className="mb-3">Ready to simplify your meal planning?</h2>
          <p className="lead mb-4">Join thousands of users who are saving time and eating better with MealAwe.</p>
          <Link to="/recipes" className="btn btn-light btn-lg px-4">Get Started Now</Link>
        </div>
      </section>
    </div>
  );
};

export default Home;
