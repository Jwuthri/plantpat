const { getSupabase } = require('../../lib/database');

module.exports = async (req, res) => {
  console.log('📅 [CREATE-REMINDER] Incoming request:', {
    method: req.method,
    hasBody: !!req.body,
    timestamp: new Date().toISOString()
  });

  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    console.log('📅 [CREATE-REMINDER] Handling CORS preflight');
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    console.log('📅 [CREATE-REMINDER] ❌ Method not allowed:', req.method);
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const supabase = getSupabase();
    const { 
      profileId, 
      plantId, 
      type, 
      title, 
      description, 
      dueDate, 
      recurring = false,
      recurringInterval = null 
    } = req.body;

    console.log('📅 [CREATE-REMINDER] 💾 Creating reminder...', {
      profileId,
      plantId,
      type,
      title,
      dueDate,
      recurring
    });

    // Validate required fields
    if (!profileId || !plantId || !type || !title || !dueDate) {
      console.error('📅 [CREATE-REMINDER] ❌ Missing required fields');
      return res.status(400).json({
        success: false,
        error: 'Missing required fields',
        required: ['profileId', 'plantId', 'type', 'title', 'dueDate']
      });
    }

    // Validate reminder type
    const validTypes = ['watering', 'fertilizing', 'health_check', 'repotting', 'custom'];
    if (!validTypes.includes(type)) {
      console.error('📅 [CREATE-REMINDER] ❌ Invalid reminder type:', type);
      return res.status(400).json({
        success: false,
        error: 'Invalid reminder type',
        validTypes
      });
    }

    // Ensure profile exists
    const { data: existingProfile } = await supabase
      .from('profiles')
      .select('id')
      .eq('id', profileId)
      .single();

    if (!existingProfile) {
      console.error('📅 [CREATE-REMINDER] ❌ Profile not found:', profileId);
      return res.status(404).json({
        success: false,
        error: 'Profile not found'
      });
    }

    // Ensure plant exists
    const { data: existingPlant } = await supabase
      .from('plants')
      .select('id, name')
      .eq('id', plantId)
      .single();

    if (!existingPlant) {
      console.error('📅 [CREATE-REMINDER] ❌ Plant not found:', plantId);
      return res.status(404).json({
        success: false,
        error: 'Plant not found'
      });
    }

    // Create reminder record
    const reminderData = {
      profile_id: profileId,
      plant_id: plantId,
      type,
      title,
      description: description || null,
      due_date: new Date(dueDate).toISOString(),
      recurring,
      recurring_interval: recurring ? recurringInterval : null,
      completed: false,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    };

    const { data: reminder, error } = await supabase
      .from('care_reminders')
      .insert(reminderData)
      .select()
      .single();

    if (error) {
      console.error('📅 [CREATE-REMINDER] ❌ Database error:', error.message);
      return res.status(500).json({
        success: false,
        error: 'Failed to create reminder',
        details: error.message
      });
    }

    console.log('📅 [CREATE-REMINDER] ✅ Reminder created successfully!', {
      reminderId: reminder.id,
      plantName: existingPlant.name,
      type: reminder.type,
      dueDate: reminder.due_date
    });

    res.status(201).json({
      success: true,
      message: 'Reminder created successfully',
      reminder: {
        ...reminder,
        plant: existingPlant
      }
    });

  } catch (error) {
    console.error('📅 [CREATE-REMINDER] ❌ Unexpected error:', error.message);
    res.status(500).json({
      success: false,
      error: 'Internal server error',
      details: error.message
    });
  }
};