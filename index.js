const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.static(path.join(__dirname, 'app/public')));

// Request logging middleware
app.use((req, res, next) => {
  const timestamp = new Date().toISOString();
  const logMessage = `${timestamp} ${req.method} ${req.path} - ${req.ip}`;
  console.log(logMessage);
  next();
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err.stack);
  res.status(500).json({
    error: 'Internal Server Error',
    timestamp: new Date().toISOString()
  });
});

// Health check endpoint
app.get('/health', (req, res) => {
  const healthCheck = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development',
    memory: {
      used: Math.round(process.memoryUsage().heapUsed / 1024 / 1024) + ' MB',
      total: Math.round(process.memoryUsage().heapTotal / 1024 / 1024) + ' MB'
    },
    version: '1.0.0'
  };

  // Log health check requests
  console.log(`Health check requested at ${healthCheck.timestamp}`);
  
  res.status(200).json(healthCheck);
});

// Readiness check endpoint
app.get('/ready', (req, res) => {
  // Add any readiness checks here (database, external services, etc.)
  res.status(200).json({
    status: 'ready',
    timestamp: new Date().toISOString()
  });
});

// Liveness check endpoint
app.get('/live', (req, res) => {
  res.status(200).json({
    status: 'alive',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
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
