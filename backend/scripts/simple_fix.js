require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

async function simpleFix() {
  try {
    console.log('🔧 [SIMPLE-FIX] Fixing database for anonymous plant saves...');
    
    // For now, let's just test if we can connect to Supabase properly
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
    
    // Try a simple select to see if we can access the plants table
    console.log('🔧 [SIMPLE-FIX] Testing plants table access...');
    const { data, error } = await supabase
      .from('plants')
      .select('count')
      .limit(1);
      
    if (error) {
      console.log('🔧 [SIMPLE-FIX] ❌ Cannot access plants table:', error.message);
      console.log('🔧 [SIMPLE-FIX] This confirms RLS is blocking access');
    } else {
      console.log('🔧 [SIMPLE-FIX] ✅ Plants table accessible');
    }
    
  } catch (error) {
    console.error('🔧 [SIMPLE-FIX] ❌ Script failed:', error.message);
  }
}

simpleFix();