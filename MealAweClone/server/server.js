const express = require('express');
const path = require('path');
const fs = require('fs');
const cors = require('cors');
const recipeRoutes = require('./routes/recipes');
const mealPlanRoutes = require('./routes/mealPlans');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Log all requests to verify routing
app.use((req, res, next) => {
  console.log(`Request received: ${req.method} ${req.url}`);
  next();
});

// Check if data directory exists, create if it doesn't
const dataDir = path.join(__dirname, 'data');
if (!fs.existsSync(dataDir)) {
  fs.mkdirSync(dataDir);
}

// Check if recipes.json exists, create empty file if it doesn't
const recipesFile = path.join(dataDir, 'recipes.json');
if (!fs.existsSync(recipesFile)) {
  fs.writeFileSync(recipesFile, JSON.stringify([], null, 2));
}

// Check if mealPlans.json exists, create empty file if it doesn't
const mealPlansFile = path.join(dataDir, 'mealPlans.json');
if (!fs.existsSync(mealPlansFile)) {
  fs.writeFileSync(mealPlansFile, JSON.stringify({}, null, 2));
}

// API Routes
app.use('/api/recipes', recipeRoutes);
app.use('/api/meal-plans', mealPlanRoutes);

// Serve static files from the React app build directory
app.use(express.static(path.join(__dirname, '..', 'dist')));

// Log all requests to verify routing
app.use((req, res, next) => {
  console.log(`Request: ${req.method} ${req.url}`);
  next();
});

// Handle root route explicitly
app.get('/', (req, res) => {
  console.log(`Serving main index.html file`);
  res.sendFile(path.join(__dirname, '..', 'dist', 'index.html'));
});

// Handle React routing, return all requests to React app
app.get('*', (req, res) => {
  console.log(`Serving React app for: ${req.url}`);
  res.sendFile(path.join(__dirname, '..', 'dist', 'index.html'));
});

// Error handler middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    message: 'An error occurred on the server',
    error: process.env.NODE_ENV === 'production' ? {} : err
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`API available at http://localhost:${PORT}/api`);
});

module.exports = app;
