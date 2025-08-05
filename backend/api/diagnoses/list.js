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
    // Get profile_id from query parameter
    const profileId = req.query.profile_id;
    
    if (!profileId) {
      return res.status(400).json({
        success: false,
        message: 'profile_id query parameter is required'
      });
    }

    console.log('🩺 [DIAGNOSES-LIST] Fetching diagnoses for profile:', profileId);
    
    // Get Supabase client
    const supabase = getSupabase();

    // Fetch diagnoses for this specific profile_id
    const { data: diagnoses, error: diagnosesError } = await supabase
      .from('diagnoses')
      .select(`
        *,
        plants:plant_id (
          id,
          name,
          species,
          scientific_name,
          confidence
        )
      `)
      .eq('profile_id', profileId)
      .order('created_at', { ascending: false });

    if (diagnosesError) {
      console.error('🩺 [DIAGNOSES-LIST] Database error:', diagnosesError.message);
      return res.status(500).json({
        success: false,
        message: 'Failed to fetch diagnoses'
      });
    }

    console.log('🩺 [DIAGNOSES-LIST] ✅ Found', diagnoses?.length || 0, 'diagnoses for profile:', profileId);

    res.status(200).json({
      success: true,
      diagnoses: diagnoses || []
    });

  } catch (error) {
    console.error('🩺 [DIAGNOSES-LIST] Unexpected error:', error.message);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};