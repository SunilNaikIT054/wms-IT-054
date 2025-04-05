const express = require('express');
const path = require('path');
const cors = require('cors');
const app = express();
const PORT = 5000;

// Enable CORS for all routes
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Log all requests
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// Health check endpoint for the feedback tool
app.get('/health', (req, res) => {
  console.log('Health check endpoint accessed');
  res.status(200).json({ status: 'UP' });
});

// Special route to help with debugging
app.get('/test-connection', (req, res) => {
  console.log('Test connection endpoint accessed');
  res.status(200).send('Connection successful!');
});

// Root route - serve a simple HTML page
app.get('/', (req, res) => {
  console.log('Serving simple HTML page for root route');
  res.send(`
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>MealAwe Test</title>
      <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; }
        h1 { color: #333; }
      </style>
    </head>
    <body>
      <h1>Hello from MealAwe Simple Test Server</h1>
      <p>This is a test page to verify the web application feedback tool.</p>
      <p>Current time: ${new Date().toLocaleString()}</p>
    </body>
    </html>
  `);
});

// Handle 404s
app.use((req, res) => {
  console.log(`404 for ${req.url}`);
  res.status(404).send('Page not found');
});

// Start server - use 0.0.0.0 to make sure we're binding to all interfaces
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Simple test server running on port ${PORT}`);
  console.log(`Server timestamp: ${new Date().toISOString()}`);
});