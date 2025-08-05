# Environment Setup for PlantPal

## Security Note
All API keys have been removed from the codebase for security reasons. You now need to provide them as environment variables when building the app.

## Required Environment Variables

When building the Flutter app, you need to provide these environment variables:

- `SUPABASE_URL`: Your Supabase project URL
- `SUPABASE_ANON_KEY`: Your Supabase anonymous key

## How to Build with Environment Variables

### Method 1: Using --dart-define flags

```bash
flutter build apk --dart-define=SUPABASE_URL=https://your-project-id.supabase.co --dart-define=SUPABASE_ANON_KEY=your-supabase-anon-key-here

flutter build ios --dart-define=SUPABASE_URL=https://your-project-id.supabase.co --dart-define=SUPABASE_ANON_KEY=your-supabase-anon-key-here
```

### Method 2: Using --dart-define-from-file

Create a file called `env.json` (add this to .gitignore):

```json
{
  "SUPABASE_URL": "https://your-project-id.supabase.co",
  "SUPABASE_ANON_KEY": "your-supabase-anon-key-here"
}
```

Then build with:

```bash
flutter build apk --dart-define-from-file=env.json
flutter build ios --dart-define-from-file=env.json
```

### For Development (flutter run)

```bash
flutter run --dart-define=SUPABASE_URL=https://your-project-id.supabase.co --dart-define=SUPABASE_ANON_KEY=your-supabase-anon-key-here
```

## Important Security Notes

1. **Never commit actual API keys to version control**
2. **Add env.json to your .gitignore if you use Method 2**
3. **Use different keys for development and production**
4. **Regularly rotate your API keys**

## Error Handling

If you forget to provide the environment variables, the app will throw a clear error message on startup indicating which environment variable is missing.