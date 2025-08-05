const { getSupabase } = require('../../lib/database');

module.exports = async (req, res) => {
  // Handle CORS preflight request
  if (req.method === 'OPTIONS') {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    res.status(200).end();
    return;
  }

  // Set CORS headers for actual request
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method !== 'GET') {
    console.log('❌ [DIAGNOSES-LIST] Method not allowed:', req.method);
    return res.status(405).json({ 
      success: false, 
      message: 'Method not allowed' 
    });
  }

  try {
    console.log('🩺 [DIAGNOSES-LIST] Fetching diagnoses (no auth for now)...');
    
    // For now, return empty list for testing - no authentication required
    console.log('🩺 [DIAGNOSES-LIST] ✅ Returning empty diagnoses list');

    res.status(200).json({
      success: true,
      diagnoses: []
    });

  } catch (error) {
    console.error('🩺 [DIAGNOSES-LIST] Unexpected error:', error.message);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};