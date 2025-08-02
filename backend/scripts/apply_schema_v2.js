require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

async function applySchemaV2() {
  try {
    console.log('🔄 [SCHEMA-V2] Applying new schema without auth.users dependencies...');
    
    const supabaseUrl = process.env.SUPABASE_URL;
    const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_ANON_KEY;
    
    console.log('Environment check:', {
      hasUrl: !!supabaseUrl,
      hasKey: !!supabaseKey,
      keyType: process.env.SUPABASE_SERVICE_ROLE_KEY ? 'service_role' : 'anon'
    });
    
    if (!supabaseUrl || !supabaseKey) {
      throw new Error('Missing Supabase environment variables');
    }
    
    const supabase = createClient(supabaseUrl, supabaseKey);
    
    // Read the new schema file
    const schemaFile = path.join(__dirname, '..', 'lib', 'schema_v2.sql');
    const schemaSQL = fs.readFileSync(schemaFile, 'utf8');
    
    console.log('🔄 [SCHEMA-V2] Applying new schema...');
    
    // Split SQL into individual statements
    const statements = schemaSQL
      .split(';')
      .map(stmt => stmt.trim())
      .filter(stmt => stmt.length > 0 && !stmt.startsWith('--'));
    
    console.log(`🔄 [SCHEMA-V2] Found ${statements.length} SQL statements to execute`);
    
    // Execute each statement
    for (let i = 0; i < statements.length; i++) {
      const statement = statements[i];
      
      if (statement.includes('DROP TABLE') || statement.includes('CREATE TABLE') || statement.includes('CREATE INDEX')) {
        console.log(`🔄 [SCHEMA-V2] [${i + 1}/${statements.length}] ${statement.substring(0, 60)}...`);
        
        try {
          // Use the SQL editor endpoint for DDL statements
          const { error } = await supabase.rpc('exec_sql', { sql: statement + ';' });
          
          if (error) {
            console.error(`🔄 [SCHEMA-V2] ❌ Error in statement ${i + 1}:`, error.message);
            if (!error.message.includes('does not exist') && !error.message.includes('already exists')) {
              throw error;
            }
          } else {
            console.log(`🔄 [SCHEMA-V2] ✅ Statement ${i + 1} executed successfully`);
          }
        } catch (err) {
          console.error(`🔄 [SCHEMA-V2] ❌ Failed to execute statement ${i + 1}:`, err.message);
          if (!err.message.includes('does not exist') && !err.message.includes('already exists')) {
            throw err;
          }
        }
      }
    }
    
    console.log('🔄 [SCHEMA-V2] ✅ Schema V2 applied successfully!');
    
    // Test the new schema by inserting a test plant
    console.log('🔄 [SCHEMA-V2] Testing new schema with anonymous plant...');
    
    const testPlant = {
      name: 'Test Plant V2',
      scientific_name: 'Testus plantus v2',
      confidence: 0.98,
      description: 'Test plant for new schema',
      tags: ['test', 'v2'],
      care_instructions: {
        watering: { frequency: 'weekly', notes: 'Water regularly' },
        lighting: { type: 'bright indirect', notes: 'Bright indirect light' }
      }
    };
    
    const { data, error } = await supabase
      .from('plants')
      .insert([testPlant])
      .select()
      .single();
      
    if (error) {
      console.error('🔄 [SCHEMA-V2] ❌ Test insert failed:', error.message);
    } else {
      console.log('🔄 [SCHEMA-V2] ✅ Test plant inserted successfully!', {
        id: data.id,
        name: data.name,
        profile_id: data.profile_id
      });
    }
    
  } catch (error) {
    console.error('🔄 [SCHEMA-V2] ❌ Schema application failed:', error.message);
    process.exit(1);
  }
}

applySchemaV2().then(() => {
  console.log('🔄 [SCHEMA-V2] ✅ All done!');
  process.exit(0);
});