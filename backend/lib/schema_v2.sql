-- PlantPal Database Schema V2 - No More Supabase Auth Dependencies
-- This completely removes auth.users dependencies and uses our own profile system

-- Drop existing tables if they exist (for clean slate)
DROP TABLE IF EXISTS care_reminders CASCADE;
DROP TABLE IF EXISTS diagnoses CASCADE;
DROP TABLE IF EXISTS plants CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;

-- Profiles table (standalone, no auth.users dependency)
CREATE TABLE profiles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email VARCHAR(255) UNIQUE,
  name VARCHAR(255) NOT NULL,
  avatar TEXT,
  password_hash TEXT, -- For when we add auth later
  email_verified BOOLEAN DEFAULT false,
  preferences JSONB DEFAULT '{"notifications": true, "theme": "system", "location": null}'::jsonb,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Plants table (linked to profiles, allows anonymous)
CREATE TABLE plants (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE, -- NULL for anonymous
  name VARCHAR(255),
  species VARCHAR(255),
  scientific_name VARCHAR(255),
  common_names TEXT[],
  description TEXT,
  images TEXT[],
  confidence NUMERIC(4,3), -- AI confidence score
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
  tags TEXT[],
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Diagnoses table (linked to profiles, allows anonymous)
CREATE TABLE diagnoses (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE, -- NULL for anonymous
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

-- Care reminders table (linked to profiles and plants)
CREATE TABLE care_reminders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
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
CREATE UNIQUE INDEX idx_profiles_email ON profiles(email) WHERE email IS NOT NULL;
CREATE INDEX idx_plants_profile_id ON plants(profile_id);
CREATE INDEX idx_plants_profile_active ON plants(profile_id, is_active);
CREATE INDEX idx_plants_created_at ON plants(created_at);
CREATE INDEX idx_diagnoses_profile_id ON diagnoses(profile_id);
CREATE INDEX idx_diagnoses_plant_id ON diagnoses(plant_id);
CREATE INDEX idx_diagnoses_status ON diagnoses(status);
CREATE INDEX idx_care_reminders_profile_id ON care_reminders(profile_id);
CREATE INDEX idx_care_reminders_plant_id ON care_reminders(plant_id);
CREATE INDEX idx_care_reminders_due_date ON care_reminders(due_date);

-- NO MORE ROW LEVEL SECURITY! 🔥
-- We'll handle permissions in the application layer

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

-- Sample data for testing
INSERT INTO profiles (name, email) VALUES 
('Test User', 'test@example.com'),
('Anonymous User', null);

COMMENT ON TABLE profiles IS 'User profiles - standalone, no auth.users dependency';
COMMENT ON TABLE plants IS 'Plant records - profile_id can be NULL for anonymous identification';
COMMENT ON TABLE diagnoses IS 'AI plant diagnoses - profile_id can be NULL for anonymous usage';
COMMENT ON TABLE care_reminders IS 'Care reminders - requires profile_id (authenticated users only)';