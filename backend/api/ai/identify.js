const aiService = require('../../lib/ai-service');
const multer = require('multer');

// Configure multer for image uploads
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB limit
  },
  fileFilter: (req, file, cb) => {
    // Accept only image files
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Only image files are allowed'), false);
    }
  },
});

module.exports = async (req, res) => {
  console.log('🌱 [AI-IDENTIFY] Incoming request:', {
    method: req.method,
    headers: Object.keys(req.headers),
    contentType: req.headers['content-type'],
    timestamp: new Date().toISOString()
  });

  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    console.log('🌱 [AI-IDENTIFY] Handling CORS preflight');
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    console.log('🌱 [AI-IDENTIFY] ❌ Method not allowed:', req.method);
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    // Handle multipart/form-data
    upload.single('image')(req, res, async (err) => {
      if (err) {
        console.error('🌱 [AI-IDENTIFY] ❌ Upload error:', err.message);
        return res.status(400).json({ error: 'Invalid image upload' });
      }

      if (!req.file) {
        // Try to handle base64 data
        if (req.body.imageData) {
          console.log('🌱 [AI-IDENTIFY] 📷 Processing base64 image data, length:', req.body.imageData.length);
          try {
            const base64Data = req.body.imageData.replace(/^data:image\/[a-z]+;base64,/, '');
            console.log('🌱 [AI-IDENTIFY] 🤖 Calling AI service...');
            const startTime = Date.now();
            
            const result = await aiService.identifyPlant(base64Data, req.body.imageType || 'image/jpeg');
            
            const processingTime = Date.now() - startTime;
            console.log('🌱 [AI-IDENTIFY] ✅ AI identification successful!', {
              processingTime: `${processingTime}ms`,
              species: result.plantIdentification?.species,
              confidence: result.plantIdentification?.confidence
            });
            
            return res.status(200).json({
              success: true,
              data: result,
              processingTime
            });
          } catch (error) {
            console.error('🌱 [AI-IDENTIFY] ❌ Plant identification error:', error.message);
            return res.status(500).json({ error: 'Failed to identify plant' });
          }
        }
        console.log('🌱 [AI-IDENTIFY] ❌ No image provided in request');
        return res.status(400).json({ error: 'No image provided' });
      }

      // Handle uploaded file
      console.log('🌱 [AI-IDENTIFY] 📷 Processing uploaded file:', {
        originalname: req.file.originalname,
        mimetype: req.file.mimetype,
        size: `${(req.file.size / 1024).toFixed(2)}KB`
      });
      
      try {
        const imageData = req.file.buffer.toString('base64');
        console.log('🌱 [AI-IDENTIFY] 🤖 Calling AI service...');
        const startTime = Date.now();
        
        const result = await aiService.identifyPlant(imageData, req.file.mimetype);
        
        const processingTime = Date.now() - startTime;
        console.log('🌱 [AI-IDENTIFY] ✅ AI identification successful!', {
          processingTime: `${processingTime}ms`,
          species: result.plantIdentification?.species,
          confidence: result.plantIdentification?.confidence
        });
        
        res.status(200).json({
          success: true,
          data: result,
          processingTime
        });
      } catch (error) {
        console.error('🌱 [AI-IDENTIFY] ❌ Plant identification error:', error.message);
        res.status(500).json({ 
          success: false,
          error: 'Failed to identify plant' 
        });
      }
    });
  } catch (error) {
    console.error('Unexpected error:', error);
    res.status(500).json({ 
      success: false,
      error: 'Internal server error' 
    });
  }
};