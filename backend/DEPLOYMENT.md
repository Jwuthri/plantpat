# PlantPal Backend Deployment Guide

## Security Status ✅

Your backend is already properly secured! All API keys are correctly using environment variables.

## Required Environment Variables

### For Vercel Deployment

Set these environment variables in your Vercel dashboard:

1. **GEMINI_API_KEY**
   - Get from: https://makersuite.google.com/app/apikey
   - Used for plant identification and diagnosis

2. **SUPABASE_URL**
   - Your Supabase project URL
   - Format: `https://your-project-id.supabase.co`

3. **SUPABASE_SERVICE_ROLE_KEY** 
   - Recommended for backend operations
   - Has admin privileges for database operations

4. **SUPABASE_ANON_KEY**
   - Fallback if SERVICE_ROLE_KEY not available
   - Limited privileges

5. **NODE_ENV**
   - Set to `production` for Vercel

## Vercel Environment Variable Setup

1. Go to your Vercel project dashboard
2. Navigate to Settings → Environment Variables
3. Add each variable:
   - **Name**: `GEMINI_API_KEY`
   - **Value**: Your actual API key
   - **Environments**: Production, Preview, Development

Repeat for all required variables.

## Local Development

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Fill in your actual values in `.env`

3. Run locally:
   ```bash
   npm install
   npm run dev
   ```

## Security Best Practices ✅

Your backend already follows these:
- ✅ No hardcoded API keys
- ✅ Environment variable validation
- ✅ Proper error handling for missing keys
- ✅ CORS headers configured
- ✅ JWT token validation

## API Endpoints

- **POST** `/api/ai/identify` - Plant identification
- **POST** `/api/ai/diagnose` - Plant health diagnosis  
- **POST** `/api/auth/login` - User authentication
- **POST** `/api/auth/register` - User registration
- **GET** `/api/auth/profile` - Get user profile
- **POST** `/api/plants/save` - Save plant data
- **POST** `/api/diagnoses/save` - Save diagnosis
- **GET** `/api/reminders/list` - List reminders
- **POST** `/api/reminders/create` - Create reminder
- **POST** `/api/reminders/complete` - Complete reminder

## Troubleshooting

If you get "Missing environment variables" errors:
1. Check Vercel dashboard environment variables
2. Ensure all required variables are set
3. Redeploy after adding variables

## Current Deployment

Your app is deployed at: https://plantpat.vercel.app/