const express = require('express');
const app = express();
const PORT = 5000;

// Add CORS headers
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  next();
});

// Log all requests
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// Simple HTML page with no external dependencies
app.get('/', (req, res) => {
  console.log('Test server: Request received for root route');
  res.send(`
    <!DOCTYPE html>
    <html>
      <head>
        <title>Test Page</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
      </head>
      <body>
        <h1>Test Page</h1>
        <p>This is a simple test page with no dependencies.</p>
      </body>
    </html>
  `);
});

// Catchall route to handle any other routes
app.get('*', (req, res) => {
  console.log(`Catchall route: ${req.url}`);
  res.send('Page not found');
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Test server running on port ${PORT}`);
});