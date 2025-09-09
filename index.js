const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.static(path.join(__dirname, 'app/public')));

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// Main route - serve HTML page
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'app/public/index.html'));
});

// API route for JSON response
app.get('/api', (req, res) => {
  res.json({
    message: 'Welcome to DevOps Takehome Application!',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    timestamp: new Date().toISOString(),
    hostname: process.env.HOSTNAME || 'unknown'
  });
});

// API routes
app.get('/api/status', (req, res) => {
  res.json({
    service: 'hello_app',
    status: 'running',
    version: '1.0.0',
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// Start server
app.listen(port, '0.0.0.0', () => {
  console.log(`Server running on port ${port}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`Health check available at: http://localhost:${port}/health`);
});
