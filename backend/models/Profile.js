const { getSupabase } = require('../lib/database');

class ProfileService {
  constructor() {
    this.supabase = getSupabase();
    this.tableName = 'profiles';
  }

  // Create a new profile (linked to Supabase auth user)
  async create(profileData) {
    try {
      const profileToCreate = {
        user_id: profileData.userId, // This should be auth.uid()
        name: profileData.name.trim(),
        avatar: profileData.avatar || null,
        preferences: {
          notifications: profileData.preferences?.notifications ?? true,
          theme: profileData.preferences?.theme || 'system',
          location: profileData.preferences?.location || null
        },
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      };

      const { data, error } = await this.supabase
        .from(this.tableName)
        .insert([profileToCreate])
        .select()
        .single();

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Find profile by user ID (auth.uid())
  async findByUserId(userId) {
    try {
      const { data, error } = await this.supabase
        .from(this.tableName)
        .select('*')
        .eq('user_id', userId)
        .single();

      if (error && error.code !== 'PGRST116') throw error; // PGRST116 is "not found"
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Find profile by profile ID
  async findById(id) {
    try {
      const { data, error } = await this.supabase
        .from(this.tableName)
        .select('*')
        .eq('id', id)
        .single();

      if (error && error.code !== 'PGRST116') throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Update profile by user ID
  async updateByUserId(userId, updateData) {
    try {
      const dataToUpdate = {
        ...updateData,
        updated_at: new Date().toISOString()
      };

      // Remove user_id from update data if present (shouldn't change)
      delete dataToUpdate.user_id;

      const { data, error } = await this.supabase
        .from(this.tableName)
        .update(dataToUpdate)
        .eq('user_id', userId)
        .select()
        .single();

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Update profile by profile ID
  async update(id, updateData) {
    try {
      const dataToUpdate = {
        ...updateData,
        updated_at: new Date().toISOString()
      };

      // Remove user_id from update data if present (shouldn't change)
      delete dataToUpdate.user_id;

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

  // Delete profile by user ID
  async deleteByUserId(userId) {
    try {
      const { error } = await this.supabase
        .from(this.tableName)
        .delete()
        .eq('user_id', userId);

      if (error) throw error;
      return true;
    } catch (error) {
      throw error;
    }
  }

  // Get all profiles (for admin purposes)
  async findAll(limit = 50, offset = 0) {
    try {
      const { data, error } = await this.supabase
        .from(this.tableName)
        .select('*')
        .range(offset, offset + limit - 1);

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Get profile with auth user data (requires authenticated context)
  async getFullProfile(userId) {
    try {
      // Get the profile data
      const profile = await this.findByUserId(userId);
      return profile;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = new ProfileService();