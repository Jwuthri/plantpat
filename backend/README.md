# PlantPal Backend

A serverless backend for the PlantPal mobile app built with Vercel and Supabase.

## Features

- **User Management**: Registration and authentication using Supabase Auth
- **Plant Management**: CRUD operations for user plants with detailed care instructions
- **AI Plant Diagnosis**: Integration with Google Gemini 2.5 Flash for plant identification and health assessment
- **Care Reminders**: Scheduled care tasks for plants
- **Image Processing**: Handle plant images for AI analysis

## Tech Stack

- **Runtime**: Node.js 18.x
- **Deployment**: Vercel (serverless functions)
- **Database**: Supabase (PostgreSQL)
- **AI**: Google Gemini 2.5 Flash
- **Image Processing**: Sharp

## Project Structure

```
backend/
├── api/                    # Vercel API routes
│   └── auth/              # Authentication endpoints
├── lib/                   # Shared utilities
│   ├── database.js        # Supabase client
│   ├── ai-service.js      # AI integration
│   └── schema.sql         # Database schema
├── models/                # Data access layer
│   ├── Profile.js        # User profile operations
│   ├── Plant.js          # Plant operations
│   ├── Diagnosis.js      # Diagnosis operations
│   └── CareReminder.js   # Reminder operations
├── package.json
└── vercel.json           # Vercel configuration
```

## Database Schema

The app uses Supabase with the following main tables:

- **auth.users**: Supabase's built-in authentication table (email, password, etc.)
- **profiles**: User profile data linked to auth.users (name, avatar, preferences)
- **plants**: User's plant collection with care instructions
- **diagnoses**: AI-powered plant analysis results
- **care_reminders**: Scheduled care tasks

All tables include proper Row Level Security (RLS) policies for user isolation and are designed for a mobile app workflow. The system uses Supabase's built-in authentication instead of custom password management.

## Key Features

### User-Centric Design
- Each user has their own isolated plant collection
- Plants are linked to users via `user_id` foreign key
- Diagnoses can be linked to specific plants or standalone
- Care reminders are plant-specific

### No JWT Tokens
- Simplified authentication without token management
- Direct user lookup by email/password
- Frontend manages user sessions

### AI Integration
- Uses Google Gemini 2.5 Flash for plant identification
- Health assessment and care recommendations
- Stores raw AI responses for debugging

### Mobile-First
- Optimized for Flutter mobile app
- Efficient data structures for mobile consumption
- Image handling for camera captures

## Environment Variables

Required environment variables:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GEMINI_AI_API_KEY=your_gemini_api_key
```

## Development

```bash
# Install dependencies
npm install

# Run locally
npm run dev

# Deploy to Vercel
vercel deploy
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login

### Plants
- User plants are managed through the Plant model
- All operations are scoped to the authenticated user

### Diagnoses
- AI-powered plant analysis
- Can be linked to existing plants or standalone

### Care Reminders
- Schedule and track plant care tasks
- Support for recurring reminders