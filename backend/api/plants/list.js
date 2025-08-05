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
    // Get profile_id from query parameter
    const profileId = req.query.profile_id;
    
    if (!profileId) {
      return res.status(400).json({
        success: false,
        message: 'profile_id query parameter is required'
      });
    }

    console.log('🌱 [PLANTS-LIST] Fetching plants for profile:', profileId);
    
    // Get Supabase client
    const supabase = getSupabase();

    // Fetch plants for this specific profile_id
    const { data: plants, error: plantsError } = await supabase
      .from('plants')
      .select('*')
      .eq('is_active', true)
      .eq('profile_id', profileId)
      .order('created_at', { ascending: false });

    if (plantsError) {
      console.error('🌱 [PLANTS-LIST] Database error:', plantsError.message);
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch plants'
      });
    }

    console.log('🌱 [PLANTS-LIST] ✅ Found', plants?.length || 0, 'plants for profile:', profileId);

    res.status(200).json({
      success: true,
      plants: plants || []
    });

  } catch (error) {
    console.error('🌱 [PLANTS-LIST] Unexpected error:', error.message);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};