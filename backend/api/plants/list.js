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
    console.log('❌ [PLANTS-LIST] Method not allowed:', req.method);
    return res.status(405).json({ 
      success: false, 
      message: 'Method not allowed' 
    });
  }

  try {
    console.log('🌱 [PLANTS-LIST] Fetching plants...');
    
    // TODO: Add authentication back later
    // For now, return empty list to test the connection
    console.log('🌱 [PLANTS-LIST] ✅ Returning empty list for testing');

    // For now, return empty list for testing
    console.log('🌱 [PLANTS-LIST] ✅ Returning empty plants list');

    res.status(200).json({
      success: true,
      plants: []
    });

  } catch (error) {
    console.error('🌱 [PLANTS-LIST] Unexpected error:', error.message);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};