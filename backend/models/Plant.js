const { getSupabase } = require('../lib/database');

class PlantService {
  constructor() {
    this.supabase = getSupabase();
    this.tableName = 'plants';
  }

  // Create a new plant
  async create(plantData) {
    try {
      const plantToCreate = {
        user_id: plantData.userId,
        name: plantData.name?.trim(),
        species: plantData.species?.trim() || null,
        scientific_name: plantData.scientificName?.trim() || null,
        common_names: plantData.commonNames || [],
        description: plantData.description?.trim() || null,
        images: plantData.images || [],
        care_instructions: {
          watering: {
            frequency: plantData.careInstructions?.watering?.frequency || null,
            amount: plantData.careInstructions?.watering?.amount || null,
            notes: plantData.careInstructions?.watering?.notes || null
          },
          lighting: {
            type: plantData.careInstructions?.lighting?.type || null,
            notes: plantData.careInstructions?.lighting?.notes || null
          },
          humidity: {
            level: plantData.careInstructions?.humidity?.level || null,
            notes: plantData.careInstructions?.humidity?.notes || null
          },
          temperature: {
            min: plantData.careInstructions?.temperature?.min || null,
            max: plantData.careInstructions?.temperature?.max || null,
            notes: plantData.careInstructions?.temperature?.notes || null
          },
          fertilizing: {
            frequency: plantData.careInstructions?.fertilizing?.frequency || null,
            type: plantData.careInstructions?.fertilizing?.type || null,
            notes: plantData.careInstructions?.fertilizing?.notes || null
          },
          repotting: {
            frequency: plantData.careInstructions?.repotting?.frequency || null,
            season: plantData.careInstructions?.repotting?.season || null,
            notes: plantData.careInstructions?.repotting?.notes || null
          }
        },
        health_status: {
          overall: plantData.healthStatus?.overall || 'unknown',
          last_check_date: plantData.healthStatus?.lastCheckDate || null,
          issues: plantData.healthStatus?.issues || []
        },
        care_history: plantData.careHistory || [],
        location: {
          room: plantData.location?.room || null,
          light_level: plantData.location?.lightLevel || null,
          position: plantData.location?.position || null,
          notes: plantData.location?.notes || null
        },
        schedule: {
          watering: {
            next_due: plantData.schedule?.watering?.nextDue || null,
            frequency: plantData.schedule?.watering?.frequency || null,
            enabled: plantData.schedule?.watering?.enabled ?? true
          },
          fertilizing: {
            next_due: plantData.schedule?.fertilizing?.nextDue || null,
            frequency: plantData.schedule?.fertilizing?.frequency || null,
            enabled: plantData.schedule?.fertilizing?.enabled ?? true
          },
          health_check: {
            next_due: plantData.schedule?.healthCheck?.nextDue || null,
            frequency: plantData.schedule?.healthCheck?.frequency || null,
            enabled: plantData.schedule?.healthCheck?.enabled ?? true
          }
        },
        is_active: plantData.isActive ?? true,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      };

      const { data, error } = await this.supabase
        .from(this.tableName)
        .insert([plantToCreate])
        .select()
        .single();

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Find plants by user ID
  async findByUserId(userId, limit = 50, offset = 0) {
    try {
      const { data, error } = await this.supabase
        .from(this.tableName)
        .select('*')
        .eq('user_id', userId)
        .eq('is_active', true)
        .order('created_at', { ascending: false })
        .range(offset, offset + limit - 1);

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Find plant by ID
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

  // Update plant
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

  // Delete plant (soft delete)
  async delete(id) {
    try {
      const { data, error } = await this.supabase
        .from(this.tableName)
        .update({ 
          is_active: false,
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

  // Get plants needing care
  async getPlantsNeedingCare(userId) {
    try {
      const today = new Date().toISOString().split('T')[0];
      
      const { data, error } = await this.supabase
        .from(this.tableName)
        .select('*')
        .eq('user_id', userId)
        .eq('is_active', true)
        .or(`schedule->>watering->>next_due.lte.${today},schedule->>fertilizing->>next_due.lte.${today},schedule->>health_check->>next_due.lte.${today}`);

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Add care history entry
  async addCareHistory(plantId, careEntry) {
    try {
      // First get the current plant
      const plant = await this.findById(plantId);
      if (!plant) throw new Error('Plant not found');

      // Add new care entry to history
      const updatedHistory = [...(plant.care_history || []), {
        ...careEntry,
        date: careEntry.date || new Date().toISOString()
      }];

      // Update the plant
      return await this.update(plantId, {
        care_history: updatedHistory
      });
    } catch (error) {
      throw error;
    }
  }

  // Search plants
  async search(userId, query, limit = 20) {
    try {
      const { data, error } = await this.supabase
        .from(this.tableName)
        .select('*')
        .eq('user_id', userId)
        .eq('is_active', true)
        .or(`name.ilike.%${query}%,species.ilike.%${query}%,scientific_name.ilike.%${query}%`)
        .limit(limit);

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = new PlantService();
