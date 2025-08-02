require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Logging middleware
app.use((req, res, next) => {
  console.log(`🌐 [SERVER] ${req.method} ${req.path}`, {
    ip: req.ip,
    userAgent: req.get('User-Agent')?.substring(0, 50),
    timestamp: new Date().toISOString()
  });
  next();
});

// Load API routes
const authRoutes = {
  login: require('./api/auth/login'),
  logout: require('./api/auth/logout'),
  profile: require('./api/auth/profile'),
  register: require('./api/auth/register')
};

const aiRoutes = {
  identify: require('./api/ai/identify'),
  diagnose: require('./api/ai/diagnose')
};

const plantRoutes = {
  save: require('./api/plants/save')
};

// Auth routes
app.all('/api/auth/login', authRoutes.login);
app.all('/api/auth/logout', authRoutes.logout);
app.all('/api/auth/profile', authRoutes.profile);
app.all('/api/auth/register', authRoutes.register);

// AI routes
app.all('/api/ai/identify', aiRoutes.identify);
app.all('/api/ai/diagnose', aiRoutes.diagnose);

// Plant routes
app.all('/api/plants/save', plantRoutes.save);

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    endpoints: [
      '/api/auth/login',
      '/api/auth/logout', 
      '/api/auth/profile',
      '/api/auth/register',
      '/api/ai/identify',
      '/api/ai/diagnose',
      '/api/plants/save'
    ]
  });
});

// Test endpoint to debug AI response
app.get('/test-ai-response', async (req, res) => {
  try {
    const aiService = require('./lib/ai-service');
    
    // Sample base64 encoded 1x1 pixel image for testing
    const testImageData = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';
    
    const result = await aiService.identifyPlant(testImageData, 'image/png');
    
    res.json({
      success: true,
      message: 'Test AI response structure',
      sampleResponse: result,
      keys: Object.keys(result || {}),
      plantIdentificationKeys: Object.keys(result?.plantIdentification || {}),
      careInstructionsKeys: Object.keys(result?.careInstructions || {})
    });
  } catch (error) {
    res.json({
      success: false,
      error: error.message,
      message: 'Failed to get AI response structure'
    });
  }
});

// 404 handler
app.use('*', (req, res) => {
  console.log(`🌐 [SERVER] ❌ 404 - Route not found: ${req.method} ${req.originalUrl}`);
  res.status(404).json({
    error: 'Not Found',
    message: `Route ${req.method} ${req.originalUrl} not found`,
    availableEndpoints: [
      'GET /health',
      'POST /api/auth/login',
      'POST /api/auth/logout', 
      'GET /api/auth/profile',
      'POST /api/auth/register',
      'POST /api/ai/identify',
      'POST /api/ai/diagnose'
    ]
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error(`🌐 [SERVER] ❌ Error:`, err.message);
  res.status(500).json({
    error: 'Internal Server Error',
    message: err.message
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 [SERVER] PlantPal Backend running!`);
  console.log(`🌐 [SERVER] Local: http://localhost:${PORT}`);
  console.log(`🌐 [SERVER] Network: http://192.168.1.106:${PORT}`);
  console.log(`🌐 [SERVER] Health check: http://192.168.1.106:${PORT}/health`);
  console.log(`💾 [SERVER] Environment: ${process.env.NODE_ENV || 'development'}`);
});