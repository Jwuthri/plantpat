-- PlantPal Database Schema for Supabase
-- This file documents the expected database structure

-- Profiles table (linked to Supabase auth.users)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID UNIQUE NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  avatar TEXT,
  preferences JSONB DEFAULT '{"notifications": true, "theme": "system", "location": null}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Plants table (per user)
CREATE TABLE IF NOT EXISTS plants (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name VARCHAR(255),
  species VARCHAR(255),
  scientific_name VARCHAR(255),
  common_names TEXT[],
  description TEXT,
  images TEXT[],
  care_instructions JSONB DEFAULT '{
    "watering": {"frequency": null, "amount": null, "notes": null},
    "lighting": {"type": null, "notes": null},
    "humidity": {"level": null, "notes": null},
    "temperature": {"min": null, "max": null, "notes": null},
    "fertilizing": {"frequency": null, "type": null, "notes": null},
    "repotting": {"frequency": null, "season": null, "notes": null}
  }'::jsonb,
  health_status JSONB DEFAULT '{
    "overall": "unknown",
    "last_check_date": null,
    "issues": []
  }'::jsonb,
  care_history JSONB DEFAULT '[]'::jsonb,
  location JSONB DEFAULT '{
    "room": null,
    "light_level": null,
    "position": null,
    "notes": null
  }'::jsonb,
  schedule JSONB DEFAULT '{
    "watering": {"next_due": null, "frequency": null, "enabled": true},
    "fertilizing": {"next_due": null, "frequency": null, "enabled": true},
    "health_check": {"next_due": null, "frequency": null, "enabled": true}
  }'::jsonb,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Diagnoses table (per user and optionally linked to plants)
CREATE TABLE IF NOT EXISTS diagnoses (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  plant_id UUID REFERENCES plants(id) ON DELETE SET NULL,
  images JSONB DEFAULT '[]'::jsonb,
  ai_analysis JSONB DEFAULT '{
    "plant_identification": {
      "species": null,
      "scientific_name": null,
      "common_names": [],
      "confidence": null,
      "alternative_matches": []
    },
    "health_assessment": {
      "overall_health": "unknown",
      "confidence": null,
      "issues": []
    },
    "care_recommendations": {
      "immediate": [],
      "ongoing": [],
      "preventive": []
    },
    "raw_response": null,
    "processing_time": null
  }'::jsonb,
  user_feedback JSONB,
  status VARCHAR(50) DEFAULT 'processing' CHECK (status IN ('processing', 'completed', 'failed')),
  error JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Care reminders table (per user)
CREATE TABLE IF NOT EXISTS care_reminders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  plant_id UUID NOT NULL REFERENCES plants(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL CHECK (type IN ('watering', 'fertilizing', 'health_check', 'repotting', 'custom')),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  due_date TIMESTAMPTZ NOT NULL,
  completed BOOLEAN DEFAULT false,
  completed_at TIMESTAMPTZ,
  recurring BOOLEAN DEFAULT false,
  recurring_interval VARCHAR(50), -- 'daily', 'weekly', 'monthly', etc.
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for better performance
CREATE UNIQUE INDEX IF NOT EXISTS idx_profiles_user_id ON profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_plants_user_id ON plants(user_id);
CREATE INDEX IF NOT EXISTS idx_plants_user_active ON plants(user_id, is_active);
CREATE INDEX IF NOT EXISTS idx_diagnoses_user_id ON diagnoses(user_id);
CREATE INDEX IF NOT EXISTS idx_diagnoses_plant_id ON diagnoses(plant_id);
CREATE INDEX IF NOT EXISTS idx_diagnoses_status ON diagnoses(status);
CREATE INDEX IF NOT EXISTS idx_care_reminders_user_id ON care_reminders(user_id);
CREATE INDEX IF NOT EXISTS idx_care_reminders_plant_id ON care_reminders(plant_id);
CREATE INDEX IF NOT EXISTS idx_care_reminders_due_date ON care_reminders(due_date);

-- Enable Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE plants ENABLE ROW LEVEL SECURITY;
ALTER TABLE diagnoses ENABLE ROW LEVEL SECURITY;
ALTER TABLE care_reminders ENABLE ROW LEVEL SECURITY;

-- RLS Policies (users can only access their own data)
CREATE POLICY "Profiles are viewable by users who own them" ON profiles FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Plants belong to user" ON plants FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Diagnoses belong to user" ON diagnoses FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Reminders belong to user" ON care_reminders FOR ALL USING (auth.uid() = user_id);

-- Updated at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at triggers
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_plants_updated_at BEFORE UPDATE ON plants FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_diagnoses_updated_at BEFORE UPDATE ON diagnoses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_care_reminders_updated_at BEFORE UPDATE ON care_reminders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();