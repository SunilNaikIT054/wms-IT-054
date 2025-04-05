import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Header from './components/Header';
import Footer from './components/Footer';
import Home from './pages/Home';
import Recipes from './pages/Recipes';
import MealPlanner from './pages/MealPlanner';
import GroceryList from './pages/GroceryList';
import RecipeDetail from './pages/RecipeDetail';
import './App.css';

function App() {
  return (
    <Router>
      <div className="app">
        <Header />
        <main className="main-content">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/recipes" element={<Recipes />} />
            <Route path="/recipes/:id" element={<RecipeDetail />} />
            <Route path="/meal-planner" element={<MealPlanner />} />
            <Route path="/grocery-list" element={<GroceryList />} />
          </Routes>
        </main>
        <Footer />
      </div>
    </Router>
  );
}

export default App;
