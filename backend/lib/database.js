require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

let supabase = null;

const initSupabase = () => {
  if (supabase) {
    console.log('💾 [DATABASE] Supabase already initialized - reusing existing connection');
    return supabase;
  }

  console.log('💾 [DATABASE] Initializing Supabase connection...');
  
  try {
    const supabaseUrl = process.env.SUPABASE_URL;
    // Use service role key for backend operations to bypass RLS
    const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_ANON_KEY;

    console.log('💾 [DATABASE] Environment check:', {
      hasUrl: !!supabaseUrl,
      hasKey: !!supabaseKey,
      usingServiceRole: !!process.env.SUPABASE_SERVICE_ROLE_KEY,
      urlHost: supabaseUrl ? new URL(supabaseUrl).hostname : 'missing'
    });

    if (!supabaseUrl || !supabaseKey) {
      console.error('💾 [DATABASE] ❌ Missing Supabase environment variables!');
      throw new Error('Missing Supabase environment variables');
    }

    supabase = createClient(supabaseUrl, supabaseKey);
    console.log('💾 [DATABASE] ✅ Supabase initialized successfully!', {
      host: new URL(supabaseUrl).hostname,
      keyType: process.env.SUPABASE_SERVICE_ROLE_KEY ? 'service_role' : 'anon',
      timestamp: new Date().toISOString()
    });
    return supabase;
  } catch (error) {
    console.error('💾 [DATABASE] ❌ Supabase initialization error:', error.message);
    throw error;
  }
};

const getSupabase = () => {
  if (!supabase) {
    return initSupabase();
  }
  return supabase;
};

module.exports = { initSupabase, getSupabase };
