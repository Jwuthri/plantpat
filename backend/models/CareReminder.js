const { getSupabase } = require('../lib/database');

class CareReminderService {
  constructor() {
    this.supabase = getSupabase();
    this.tableName = 'care_reminders';
  }

  // Create a new care reminder
  async create(reminderData) {
    try {
      const reminderToCreate = {
        user_id: reminderData.userId,
        plant_id: reminderData.plantId,
        type: reminderData.type,
        title: reminderData.title?.trim(),
        description: reminderData.description?.trim() || null,
        due_date: reminderData.dueDate,
        completed: reminderData.completed ?? false,
        completed_at: reminderData.completedAt || null,
        recurring: reminderData.recurring ?? false,
        recurring_interval: reminderData.recurringInterval || null,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      };

      const { data, error } = await this.supabase
        .from(this.tableName)
        .insert([reminderToCreate])
        .select()
        .single();

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Find reminders by user ID
  async findByUserId(userId, limit = 50, offset = 0) {
    try {
      const { data, error } = await this.supabase
        .from(this.tableName)
        .select(`
          *,
          plants (
            id,
            name,
            species,
            images
          )
        `)
        .eq('user_id', userId)
        .order('due_date', { ascending: true })
        .range(offset, offset + limit - 1);

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Find reminders by plant ID
  async findByPlantId(plantId, limit = 20) {
    try {
      const { data, error } = await this.supabase
        .from(this.tableName)
        .select('*')
        .eq('plant_id', plantId)
        .order('due_date', { ascending: true })
        .limit(limit);

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Find reminder by ID
  async findById(id) {
    try {
      const { data, error } = await this.supabase
        .from(this.tableName)
        .select(`
          *,
          plants (
            id,
            name,
            species,
            images
          )
        `)
        .eq('id', id)
        .single();

      if (error && error.code !== 'PGRST116') throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Update reminder
  async update(id, updateData) {
    try {
      const dataToUpdate = {
        ...updateData,
        updated_at: new Date().toISOString()
      };

      const { data, error } = await this.supabase
        .from(this.tableName)
        .update(dataToUpdate)
        .eq('id', id)
        .select()
        .single();

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Mark reminder as completed
  async markCompleted(id) {
    try {
      const { data, error } = await this.supabase
        .from(this.tableName)
        .update({
          completed: true,
          completed_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        })
        .eq('id', id)
        .select()
        .single();

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Delete reminder
  async delete(id) {
    try {
      const { error } = await this.supabase
        .from(this.tableName)
        .delete()
        .eq('id', id);

      if (error) throw error;
      return true;
    } catch (error) {
      throw error;
    }
  }

  // Get pending reminders for user
  async getPendingReminders(userId) {
    try {
      const { data, error } = await this.supabase
        .from(this.tableName)
        .select(`
          *,
          plants (
            id,
            name,
            species,
            images
          )
        `)
        .eq('user_id', userId)
        .eq('completed', false)
        .lte('due_date', new Date().toISOString())
        .order('due_date', { ascending: true });

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Get upcoming reminders for user
  async getUpcomingReminders(userId, days = 7) {
    try {
      const futureDate = new Date();
      futureDate.setDate(futureDate.getDate() + days);

      const { data, error } = await this.supabase
        .from(this.tableName)
        .select(`
          *,
          plants (
            id,
            name,
            species,
            images
          )
        `)
        .eq('user_id', userId)
        .eq('completed', false)
        .gte('due_date', new Date().toISOString())
        .lte('due_date', futureDate.toISOString())
        .order('due_date', { ascending: true });

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Get reminder statistics for user
  async getReminderStats(userId) {
    try {
      // Get total reminders
      const { count: totalCount, error: totalError } = await this.supabase
        .from(this.tableName)
        .select('*', { count: 'exact', head: true })
        .eq('user_id', userId);

      if (totalError) throw totalError;

      // Get pending reminders
      const { count: pendingCount, error: pendingError } = await this.supabase
        .from(this.tableName)
        .select('*', { count: 'exact', head: true })
        .eq('user_id', userId)
        .eq('completed', false)
        .lte('due_date', new Date().toISOString());

      if (pendingError) throw pendingError;

      // Get completed reminders
      const { count: completedCount, error: completedError } = await this.supabase
        .from(this.tableName)
        .select('*', { count: 'exact', head: true })
        .eq('user_id', userId)
        .eq('completed', true);

      if (completedError) throw completedError;

      return {
        total: totalCount || 0,
        pending: pendingCount || 0,
        completed: completedCount || 0,
        upcoming: (totalCount || 0) - (pendingCount || 0) - (completedCount || 0)
      };
    } catch (error) {
      throw error;
    }
  }
}

module.exports = new CareReminderService();