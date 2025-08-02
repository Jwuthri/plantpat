const { getSupabase } = require('../lib/database');

class DiagnosisService {
  constructor() {
    this.supabase = getSupabase();
    this.tableName = 'diagnoses';
  }

  // Create a new diagnosis
  async create(diagnosisData) {
    try {
      const diagnosisToCreate = {
        user_id: diagnosisData.userId,
        plant_id: diagnosisData.plantId || null,
        images: diagnosisData.images || [],
        ai_analysis: {
          plant_identification: {
            species: diagnosisData.aiAnalysis?.plantIdentification?.species || null,
            scientific_name: diagnosisData.aiAnalysis?.plantIdentification?.scientificName || null,
            common_names: diagnosisData.aiAnalysis?.plantIdentification?.commonNames || [],
            confidence: diagnosisData.aiAnalysis?.plantIdentification?.confidence || null,
            alternative_matches: diagnosisData.aiAnalysis?.plantIdentification?.alternativeMatches || []
          },
          health_assessment: {
            overall_health: diagnosisData.aiAnalysis?.healthAssessment?.overallHealth || 'unknown',
            confidence: diagnosisData.aiAnalysis?.healthAssessment?.confidence || null,
            issues: diagnosisData.aiAnalysis?.healthAssessment?.issues || []
          },
          care_recommendations: {
            immediate: diagnosisData.aiAnalysis?.careRecommendations?.immediate || [],
            ongoing: diagnosisData.aiAnalysis?.careRecommendations?.ongoing || [],
            preventive: diagnosisData.aiAnalysis?.careRecommendations?.preventive || []
          },
          raw_response: diagnosisData.aiAnalysis?.rawResponse || null,
          processing_time: diagnosisData.aiAnalysis?.processingTime || null
        },
        user_feedback: diagnosisData.userFeedback || null,
        status: diagnosisData.status || 'processing',
        error: diagnosisData.error || null,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      };

      const { data, error } = await this.supabase
        .from(this.tableName)
        .insert([diagnosisToCreate])
        .select()
        .single();

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Find diagnoses by user ID
  async findByUserId(userId, limit = 50, offset = 0) {
    try {
      const { data, error } = await this.supabase
        .from(this.tableName)
        .select('*')
        .eq('user_id', userId)
        .order('created_at', { ascending: false })
        .range(offset, offset + limit - 1);

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Find diagnosis by ID
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

  // Update diagnosis
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

  // Delete diagnosis
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

  // Find diagnoses by plant ID
  async findByPlantId(plantId, limit = 20) {
    try {
      const { data, error } = await this.supabase
        .from(this.tableName)
        .select('*')
        .eq('plant_id', plantId)
        .order('created_at', { ascending: false })
        .limit(limit);

      if (error) throw error;
      return data;
    } catch (error) {
      throw error;
    }
  }

  // Update diagnosis status
  async updateStatus(id, status, error = null) {
    try {
      const updateData = {
        status,
        updated_at: new Date().toISOString()
      };

      if (error) {
        updateData.error = {
          message: error.message,
          code: error.code || 'UNKNOWN',
          occurred_at: new Date().toISOString()
        };
      }

      const { data, error: dbError } = await this.supabase
        .from(this.tableName)
        .update(updateData)
        .eq('id', id)
        .select()
        .single();

      if (dbError) throw dbError;
      return data;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = new DiagnosisService();
