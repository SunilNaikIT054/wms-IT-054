import React, { useState } from 'react';

const SearchBar = ({ onSearch, placeholder = "Search recipes..." }) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [filters, setFilters] = useState({
    category: '',
    difficulty: '',
    time: '',
    dietary: ''
  });
  const [showFilters, setShowFilters] = useState(false);

  const handleSearchSubmit = (e) => {
    e.preventDefault();
    onSearch({ searchTerm, ...filters });
  };

  const handleFilterChange = (e) => {
    const { name, value } = e.target;
    setFilters(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const toggleFilters = () => {
    setShowFilters(!showFilters);
  };

  const clearFilters = () => {
    setSearchTerm('');
    setFilters({
      category: '',
      difficulty: '',
      time: '',
      dietary: ''
    });
    onSearch({ searchTerm: '', category: '', difficulty: '', time: '', dietary: '' });
  };

  return (
    <div className="search-bar-container mb-4">
      <form onSubmit={handleSearchSubmit}>
        <div className="input-group mb-3">
          <input
            type="text"
            className="form-control"
            placeholder={placeholder}
            aria-label="Search"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
          <button className="btn btn-outline-success" type="button" onClick={toggleFilters}>
            <i className="fas fa-filter"></i>
          </button>
          <button className="btn btn-success" type="submit">
            <i className="fas fa-search"></i>
          </button>
        </div>

        {showFilters && (
          <div className="card p-3 mb-3">
            <div className="row g-3">
              <div className="col-md-3">
                <label className="form-label">Category</label>
                <select
                  className="form-select"
                  name="category"
                  value={filters.category}
                  onChange={handleFilterChange}
                >
                  <option value="">All Categories</option>
                  <option value="breakfast">Breakfast</option>
                  <option value="lunch">Lunch</option>
                  <option value="dinner">Dinner</option>
                  <option value="desserts">Desserts</option>
                  <option value="snacks">Snacks</option>
                  <option value="drinks">Drinks</option>
                </select>
              </div>

              <div className="col-md-3">
                <label className="form-label">Difficulty</label>
                <select
                  className="form-select"
                  name="difficulty"
                  value={filters.difficulty}
                  onChange={handleFilterChange}
                >
                  <option value="">Any Difficulty</option>
                  <option value="easy">Easy</option>
                  <option value="medium">Medium</option>
                  <option value="hard">Hard</option>
                </select>
              </div>

              <div className="col-md-3">
                <label className="form-label">Cooking Time</label>
                <select
                  className="form-select"
                  name="time"
                  value={filters.time}
                  onChange={handleFilterChange}
                >
                  <option value="">Any Time</option>
                  <option value="15">Under 15 minutes</option>
                  <option value="30">Under 30 minutes</option>
                  <option value="60">Under 1 hour</option>
                  <option value="120">Under 2 hours</option>
                </select>
              </div>

              <div className="col-md-3">
                <label className="form-label">Dietary</label>
                <select
                  className="form-select"
                  name="dietary"
                  value={filters.dietary}
                  onChange={handleFilterChange}
                >
                  <option value="">No Restrictions</option>
                  <option value="vegetarian">Vegetarian</option>
                  <option value="vegan">Vegan</option>
                  <option value="gluten-free">Gluten-Free</option>
                  <option value="dairy-free">Dairy-Free</option>
                  <option value="keto">Keto</option>
                  <option value="low-carb">Low Carb</option>
                </select>
              </div>
            </div>

            <div className="d-flex justify-content-end mt-3">
              <button 
                type="button" 
                className="btn btn-outline-secondary me-2"
                onClick={clearFilters}
              >
                Clear Filters
              </button>
              <button type="submit" className="btn btn-success">
                Apply Filters
              </button>
            </div>
          </div>
        )}
      </form>
    </div>
  );
};

export default SearchBar;
