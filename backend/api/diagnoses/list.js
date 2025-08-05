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
    console.log('🩺 [DIAGNOSES-LIST] Fetching diagnoses...');
    
    // Get authorization header
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'No authorization token provided'
      });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix
    
    // Get Supabase client
    const supabase = getSupabase();

    // Verify the token and get user
    const { data: { user }, error: authError } = await supabase.auth.getUser(token);
    if (authError || !user) {
      console.error('🩺 [DIAGNOSES-LIST] Auth error:', authError?.message);
      return res.status(401).json({
        success: false,
        message: 'Invalid or expired token'
      });
    }

    console.log('🩺 [DIAGNOSES-LIST] ✅ User authenticated:', user.email);

    // Get user's profile to get profile_id
    const { data: profileData, error: profileError } = await supabase
      .from('profiles')
      .select('id')
      .eq('email', user.email)
      .single();

    if (profileError || !profileData) {
      console.error('🩺 [DIAGNOSES-LIST] Profile error:', profileError?.message);
      return res.status(404).json({
        success: false,
        message: 'User profile not found'
      });
    }

    const profileId = profileData.id;
    console.log('🩺 [DIAGNOSES-LIST] Profile ID:', profileId);

    // Fetch diagnoses for this user with plant data
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

    console.log('🩺 [DIAGNOSES-LIST] ✅ Found', diagnoses?.length || 0, 'diagnoses');

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