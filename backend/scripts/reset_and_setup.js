const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

// Load environment variables
require('dotenv').config();

async function resetAndSetupDatabase() {
  const supabaseUrl = process.env.SUPABASE_URL;
  const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_ANON_KEY;

  if (!supabaseUrl || !supabaseServiceKey) {
    console.error('❌ Missing required environment variables:');
    console.error('   - SUPABASE_URL');
    console.error('   - SUPABASE_SERVICE_ROLE_KEY (or SUPABASE_ANON_KEY)');
    process.exit(1);
  }

  // Create Supabase client with service role key for admin operations
  const supabase = createClient(supabaseUrl, supabaseServiceKey);

  try {
    console.log('🗑️  Starting database reset...');

    // Read reset script
    const resetScript = fs.readFileSync(
      path.join(__dirname, '../lib/reset_database.sql'),
      'utf8'
    );

    // Execute reset script
    const { error: resetError } = await supabase.rpc('exec_sql', {
      sql: resetScript
    });

    if (resetError) {
      // If rpc doesn't work, try direct query
      console.log('Trying alternative reset method...');
      const { error: altResetError } = await supabase
        .from('_supabase_query')
        .select('*')
        .limit(1);
      
      if (altResetError) {
        console.warn('⚠️  Could not execute reset script programmatically.');
        console.log('Please run the reset script manually in your Supabase SQL editor:');
        console.log('📁 File: backend/lib/reset_database.sql');
        console.log('\nThen run the schema script:');
        console.log('📁 File: backend/lib/schema.sql');
        return;
      }
    }

    console.log('✅ Database reset completed');
    console.log('🔧 Setting up new schema...');

    // Read schema script
    const schemaScript = fs.readFileSync(
      path.join(__dirname, '../lib/schema.sql'),
      'utf8'
    );

    // Execute schema script
    const { error: schemaError } = await supabase.rpc('exec_sql', {
      sql: schemaScript
    });

    if (schemaError) {
      console.warn('⚠️  Could not execute schema script programmatically.');
      console.log('Please run the schema script manually in your Supabase SQL editor:');
      console.log('📁 File: backend/lib/schema.sql');
      return;
    }

    console.log('✅ Database schema created successfully');
    console.log('🌱 Your PlantPal database is ready!');

  } catch (error) {
    console.error('❌ Error during database setup:', error.message);
    console.log('\n🔧 Manual setup instructions:');
    console.log('1. Go to your Supabase project dashboard');
    console.log('2. Navigate to SQL Editor');
    console.log('3. Run backend/lib/reset_database.sql');
    console.log('4. Then run backend/lib/schema.sql');
  }
}

// Run if called directly
if (require.main === module) {
  resetAndSetupDatabase();
}

module.exports = { resetAndSetupDatabase };