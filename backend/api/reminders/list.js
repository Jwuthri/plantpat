const { getSupabase } = require('../../lib/database');

module.exports = async (req, res) => {
  console.log('📅 [LIST-REMINDERS] Incoming request:', {
    method: req.method,
    query: req.query,
    timestamp: new Date().toISOString()
  });

  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    console.log('📅 [LIST-REMINDERS] Handling CORS preflight');
    return res.status(200).end();
  }

  if (req.method !== 'GET') {
    console.log('📅 [LIST-REMINDERS] ❌ Method not allowed:', req.method);
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const supabase = getSupabase();
    const { profileId, plantId, status } = req.query;

    console.log('📅 [LIST-REMINDERS] 📋 Fetching reminders...', {
      profileId,
      plantId,
      status
    });

    // Build query
    let query = supabase
      .from('care_reminders')
      .select(`
        *,
        plants:plant_id (id, name, species, images)
      `)
      .order('due_date', { ascending: true });

    // Filter by profile
    if (profileId) {
      query = query.eq('profile_id', profileId);
    }

    // Filter by plant
    if (plantId) {
      query = query.eq('plant_id', plantId);
    }

    // Filter by completion status
    if (status === 'pending') {
      query = query.eq('completed', false);
    } else if (status === 'completed') {
      query = query.eq('completed', true);
    }

    const { data: reminders, error } = await query;

    if (error) {
      console.error('📅 [LIST-REMINDERS] ❌ Database error:', error.message);
      return res.status(500).json({
        success: false,
        error: 'Failed to fetch reminders',
        details: error.message
      });
    }

    console.log('📅 [LIST-REMINDERS] ✅ Successfully fetched reminders:', {
      count: reminders.length,
      pending: reminders.filter(r => !r.completed).length,
      completed: reminders.filter(r => r.completed).length
    });

    res.status(200).json({
      success: true,
      reminders: reminders || [],
      count: reminders?.length || 0
    });

  } catch (error) {
    console.error('📅 [LIST-REMINDERS] ❌ Unexpected error:', error.message);
    res.status(500).json({
      success: false,
      error: 'Internal server error',
      details: error.message
    });
  }
};