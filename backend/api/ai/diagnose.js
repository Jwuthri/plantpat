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
  console.log('🩺 [AI-DIAGNOSE] Incoming request:', {
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
    console.log('🩺 [AI-DIAGNOSE] Handling CORS preflight');
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    console.log('🩺 [AI-DIAGNOSE] ❌ Method not allowed:', req.method);
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    // Handle multipart/form-data
    upload.single('image')(req, res, async (err) => {
      if (err) {
        console.error('Upload error:', err);
        return res.status(400).json({ error: 'Invalid image upload' });
      }

      if (!req.file) {
        // Try to handle base64 data
        if (req.body.imageData) {
          console.log('🩺 [AI-DIAGNOSE] 📷 Processing base64 image data, length:', req.body.imageData.length);
          console.log('🩺 [AI-DIAGNOSE] 🔍 Plant context provided:', !!req.body.plantContext);
          try {
            const base64Data = req.body.imageData.replace(/^data:image\/[a-z]+;base64,/, '');
            const plantContext = req.body.plantContext || null;
            
            console.log('🩺 [AI-DIAGNOSE] 🤖 Calling AI service...');
            const startTime = Date.now();
            
            const result = await aiService.diagnosePlantHealth(
              base64Data, 
              req.body.imageType || 'image/jpeg',
              plantContext
            );
            
            const processingTime = Date.now() - startTime;
            console.log('🩺 [AI-DIAGNOSE] ✅ AI diagnosis successful!', {
              processingTime: `${processingTime}ms`,
              overallHealth: result.healthAssessment?.overallHealth,
              issuesFound: result.healthAssessment?.issues?.length || 0
            });
            
            return res.status(200).json({
              success: true,
              data: result,
              processingTime
            });
          } catch (error) {
            console.error('🩺 [AI-DIAGNOSE] ❌ Plant diagnosis error:', error.message);
            return res.status(500).json({ error: 'Failed to diagnose plant' });
          }
        }
        console.log('🩺 [AI-DIAGNOSE] ❌ No image provided in request');
        return res.status(400).json({ error: 'No image provided' });
      }

      // Handle uploaded file
      console.log('🩺 [AI-DIAGNOSE] 📷 Processing uploaded file:', {
        originalname: req.file.originalname,
        mimetype: req.file.mimetype,
        size: `${(req.file.size / 1024).toFixed(2)}KB`
      });
      
      try {
        const imageData = req.file.buffer.toString('base64');
        const plantContext = JSON.parse(req.body.plantContext || 'null');
        
        console.log('🩺 [AI-DIAGNOSE] 🤖 Calling AI service...');
        const startTime = Date.now();
        
        const result = await aiService.diagnosePlantHealth(
          imageData, 
          req.file.mimetype,
          plantContext
        );
        
        const processingTime = Date.now() - startTime;
        console.log('🩺 [AI-DIAGNOSE] ✅ AI diagnosis successful!', {
          processingTime: `${processingTime}ms`,
          overallHealth: result.healthAssessment?.overallHealth,
          issuesFound: result.healthAssessment?.issues?.length || 0
        });
        
        res.status(200).json({
          success: true,
          data: result,
          processingTime
        });
      } catch (error) {
        console.error('🩺 [AI-DIAGNOSE] ❌ Plant diagnosis error:', error.message);
        res.status(500).json({ 
          success: false,
          error: 'Failed to diagnose plant' 
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