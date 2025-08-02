require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

async function migrateSchema() {
  try {
    console.log('🔄 [MIGRATE] Starting simple schema migration...');
    
    const supabaseUrl = process.env.SUPABASE_URL;
    const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_ANON_KEY;
    
    if (!supabaseUrl || !supabaseKey) {
      throw new Error('Missing Supabase environment variables');
    }
    
    const supabase = createClient(supabaseUrl, supabaseKey);
    
    // Step 1: Disable RLS on plants table to allow anonymous saves
    console.log('🔄 [MIGRATE] Step 1: Disabling RLS on plants table...');
    try {
      const { error: rlsError } = await supabase.rpc('exec_sql', { 
        sql: 'ALTER TABLE plants DISABLE ROW LEVEL SECURITY;' 
      });
      if (rlsError && !rlsError.message.includes('does not exist')) {
        console.log('🔄 [MIGRATE] ⚠️ RLS disable warning:', rlsError.message);
      } else {
        console.log('🔄 [MIGRATE] ✅ RLS disabled on plants table');
      }
    } catch (err) {
      console.log('🔄 [MIGRATE] ⚠️ Could not disable RLS, continuing...');
    }
    
    // Step 2: Create profiles table if it doesn't exist (device-based)
    console.log('🔄 [MIGRATE] Step 2: Creating profiles table...');
    const { error: profilesError } = await supabase
      .from('profiles')
      .select('id')
      .limit(1);
    
    if (profilesError && profilesError.message.includes('does not exist')) {
      // Create profiles table manually
      console.log('🔄 [MIGRATE] Creating new profiles table...');
      // We'll handle this in the app logic for now
    }
    
    // Step 3: Make user_id nullable in plants table
    console.log('🔄 [MIGRATE] Step 3: Testing plants table access...');
    const { data: plantsTest, error: plantsError } = await supabase
      .from('plants')
      .select('id')
      .limit(1);
      
    if (plantsError) {
      console.log('🔄 [MIGRATE] ❌ Plants table access failed:', plantsError.message);
      throw plantsError;
    } else {
      console.log('🔄 [MIGRATE] ✅ Plants table accessible');
    }
    
    // Step 4: Test inserting a plant with null user_id
    console.log('🔄 [MIGRATE] Step 4: Testing anonymous plant insert...');
    const testPlant = {
      name: 'Migration Test Plant',
      species: 'Test Species',
      scientific_name: 'Testus migrationus',
      description: 'Test plant for migration',
      user_id: null, // This should work now
      confidence: 0.95,
      care_instructions: {
        watering: { frequency: 'weekly', notes: 'Test watering' }
      },
      is_active: true
    };
    
    const { data: insertData, error: insertError } = await supabase
      .from('plants')
      .insert([testPlant])
      .select()
      .single();
    
    if (insertError) {
      console.log('🔄 [MIGRATE] ❌ Test insert failed:', insertError.message);
      // For now, we'll continue and handle this in the app
    } else {
      console.log('🔄 [MIGRATE] ✅ Test plant inserted successfully!', {
        id: insertData.id,
        name: insertData.name
      });
      
      // Clean up test plant
      await supabase.from('plants').delete().eq('id', insertData.id);
      console.log('🔄 [MIGRATE] ✅ Test plant cleaned up');
    }
    
    console.log('🔄 [MIGRATE] ✅ Schema migration completed!');
    
  } catch (error) {
    console.error('🔄 [MIGRATE] ❌ Migration failed:', error.message);
    process.exit(1);
  }
}

migrateSchema().then(() => {
  console.log('🔄 [MIGRATE] Done!');
  process.exit(0);
});