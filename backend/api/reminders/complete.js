const { getSupabase } = require('../../lib/database');

module.exports = async (req, res) => {
  console.log('📅 [COMPLETE-REMINDER] Incoming request:', {
    method: req.method,
    hasBody: !!req.body,
    timestamp: new Date().toISOString()
  });

  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    console.log('📅 [COMPLETE-REMINDER] Handling CORS preflight');
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    console.log('📅 [COMPLETE-REMINDER] ❌ Method not allowed:', req.method);
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const supabase = getSupabase();
    const { reminderId, profileId } = req.body;

    console.log('📅 [COMPLETE-REMINDER] ✅ Marking reminder as complete...', {
      reminderId,
      profileId
    });

    // Validate required fields
    if (!reminderId || !profileId) {
      console.error('📅 [COMPLETE-REMINDER] ❌ Missing required fields');
      return res.status(400).json({
        success: false,
        error: 'Missing required fields',
        required: ['reminderId', 'profileId']
      });
    }

    // Fetch the existing reminder
    const { data: existingReminder, error: fetchError } = await supabase
      .from('care_reminders')
      .select('*')
      .eq('id', reminderId)
      .eq('profile_id', profileId)
      .single();

    if (fetchError || !existingReminder) {
      console.error('📅 [COMPLETE-REMINDER] ❌ Reminder not found:', fetchError?.message);
      return res.status(404).json({
        success: false,
        error: 'Reminder not found'
      });
    }

    if (existingReminder.completed) {
      console.log('📅 [COMPLETE-REMINDER] ⚠️ Reminder already completed');
      return res.status(200).json({
        success: true,
        message: 'Reminder already completed',
        reminder: existingReminder
      });
    }

    const now = new Date().toISOString();
    let updates = {
      completed: true,
      completed_at: now,
      updated_at: now
    };

    // If recurring, create next reminder
    let nextReminder = null;
    if (existingReminder.recurring && existingReminder.recurring_interval) {
      const currentDueDate = new Date(existingReminder.due_date);
      let nextDueDate = new Date(currentDueDate);

      // Calculate next due date based on interval
      switch (existingReminder.recurring_interval) {
        case 'daily':
          nextDueDate.setDate(nextDueDate.getDate() + 1);
          break;
        case 'weekly':
          nextDueDate.setDate(nextDueDate.getDate() + 7);
          break;
        case 'monthly':
          nextDueDate.setMonth(nextDueDate.getMonth() + 1);
          break;
        case 'yearly':
          nextDueDate.setFullYear(nextDueDate.getFullYear() + 1);
          break;
        default:
          console.warn('📅 [COMPLETE-REMINDER] ⚠️ Unknown recurring interval:', existingReminder.recurring_interval);
      }

      // Create next occurrence
      if (nextDueDate > currentDueDate) {
        const nextReminderData = {
          profile_id: existingReminder.profile_id,
          plant_id: existingReminder.plant_id,
          type: existingReminder.type,
          title: existingReminder.title,
          description: existingReminder.description,
          due_date: nextDueDate.toISOString(),
          recurring: true,
          recurring_interval: existingReminder.recurring_interval,
          completed: false,
          created_at: now,
          updated_at: now
        };

        const { data: newReminder, error: createError } = await supabase
          .from('care_reminders')
          .insert(nextReminderData)
          .select()
          .single();

        if (createError) {
          console.error('📅 [COMPLETE-REMINDER] ⚠️ Failed to create next reminder:', createError.message);
        } else {
          nextReminder = newReminder;
          console.log('📅 [COMPLETE-REMINDER] ✅ Next reminder created:', {
            id: newReminder.id,
            dueDate: newReminder.due_date
          });
        }
      }
    }

    // Update current reminder as completed
    const { data: updatedReminder, error: updateError } = await supabase
      .from('care_reminders')
      .update(updates)
      .eq('id', reminderId)
      .select()
      .single();

    if (updateError) {
      console.error('📅 [COMPLETE-REMINDER] ❌ Database error:', updateError.message);
      return res.status(500).json({
        success: false,
        error: 'Failed to complete reminder',
        details: updateError.message
      });
    }

    console.log('📅 [COMPLETE-REMINDER] ✅ Reminder completed successfully!', {
      reminderId: updatedReminder.id,
      completedAt: updatedReminder.completed_at,
      hasNextReminder: !!nextReminder
    });

    res.status(200).json({
      success: true,
      message: 'Reminder completed successfully',
      reminder: updatedReminder,
      nextReminder: nextReminder
    });

  } catch (error) {
    console.error('📅 [COMPLETE-REMINDER] ❌ Unexpected error:', error.message);
    res.status(500).json({
      success: false,
      error: 'Internal server error',
      details: error.message
    });
  }
};