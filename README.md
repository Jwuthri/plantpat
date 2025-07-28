# PlantPal 🌱

**Instant Plant Care & Diagnosis**

PlantPal is a Flutter app that uses AI-powered image recognition to identify plants and diagnose health issues, helping users care for their green friends with personalized guidance and reminders.

## 🚀 Features

### 📷 **AI-Powered Plant Analysis**
- **Plant Identification**: Snap a photo to instantly identify plant species
- **Health Diagnosis**: Detect diseases, pests, and care issues from leaf photos
- **Powered by Gemini 2.5 Flash**: Advanced AI for accurate recognition

### 🌿 **Comprehensive Plant Care**
- **Care Instructions**: Personalized care tips based on plant type and region
- **Smart Reminders**: Notifications for watering, fertilizing, and repotting
- **Care Tracking**: Log watering, fertilizing, and plant health over time

### 📱 **User-Friendly Interface**
- **Beautiful Design**: Modern, plant-themed UI with light/dark mode support
- **Garden Dashboard**: Overview of your plant collection and care status
- **Plant Profiles**: Detailed information and care history for each plant

### 🔧 **Technical Features**
- **Cross-Platform**: Built with Flutter for iOS and Android
- **Real-time Sync**: Supabase backend for data synchronization
- **Offline Support**: Core features work without internet connection
- **Cloud Storage**: Secure plant photos and data backup

## 🛠️ Installation & Setup

### Prerequisites
- Flutter SDK (>=3.13.0)
- Dart SDK (>=3.1.0)
- Supabase account
- Gemini API key

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/plantpal.git
cd plantpal
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure Environment Variables

#### Supabase Setup
1. Create a new project at [supabase.com](https://supabase.com)
2. Go to Settings > API to get your URL and anon key
3. Update `lib/core/config/supabase_config.dart`:

```dart
class SupabaseConfig {
  static const String url = 'https://your-project.supabase.co';
  static const String anonKey = 'your-anon-key-here';
}
```

#### Gemini AI Setup
1. Get your API key from [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Update `lib/core/services/ai_service.dart`:

```dart
class AIService {
  static const String _geminiApiKey = 'your-gemini-api-key-here';
  // ...
}
```

### 4. Database Setup

Create the following tables in your Supabase project:

```sql
-- Plants table
CREATE TABLE plants (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  scientific_name TEXT NOT NULL,
  common_name TEXT NOT NULL,
  category TEXT NOT NULL,
  image_url TEXT NOT NULL,
  description TEXT NOT NULL,
  care_info JSONB NOT NULL,
  tags TEXT[] DEFAULT '{}',
  is_favorite BOOLEAN DEFAULT FALSE,
  is_deleted BOOLEAN DEFAULT FALSE,
  user_notes TEXT,
  last_watered TIMESTAMPTZ,
  last_fertilized TIMESTAMPTZ,
  next_watering_date TIMESTAMPTZ,
  next_fertilizing_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Diagnoses table
CREATE TABLE diagnoses (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  plant_id UUID REFERENCES plants(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  detected_issues JSONB NOT NULL DEFAULT '[]',
  overall_health_score DECIMAL(3,2) NOT NULL,
  status TEXT NOT NULL DEFAULT 'completed',
  is_deleted BOOLEAN DEFAULT FALSE,
  user_notes TEXT,
  treatment_applied TEXT,
  follow_up_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Care reminders table
CREATE TABLE care_reminders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  plant_id UUID REFERENCES plants(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  type TEXT NOT NULL,
  scheduled_date TIMESTAMPTZ NOT NULL,
  frequency JSONB NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  is_active BOOLEAN DEFAULT TRUE,
  is_deleted BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMPTZ,
  next_reminder_date TIMESTAMPTZ,
  notes TEXT,
  instructions TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 5. Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 6. Run the App
```bash
flutter run
```

## 🎯 Usage

### Plant Identification
1. Tap the camera button on the home screen
2. Select "Identify Plant"
3. Take a photo or choose from gallery
4. Review AI identification results
5. Save to your plant collection

### Health Diagnosis
1. Navigate to camera screen
2. Select "Health Diagnosis"
3. Focus on problematic areas of the plant
4. Get AI-powered diagnosis and treatment recommendations

### Plant Care Management
1. View your plant collection
2. Set up care reminders
3. Track watering and fertilizing
4. Monitor plant health over time

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── router/          # Navigation setup
│   ├── services/        # External services (AI, etc.)
│   └── theme/           # App theming
├── features/
│   ├── camera/          # Camera & AI functionality
│   ├── diagnosis/       # Health diagnosis
│   ├── home/           # Dashboard
│   ├── plants/         # Plant management
│   └── reminders/      # Care reminders
└── shared/
    └── presentation/   # Shared UI components
```

### State Management
- **Riverpod**: For state management and dependency injection
- **Freezed**: For immutable data classes
- **Go Router**: For navigation and deep linking

### Backend Services
- **Supabase**: Database, authentication, and real-time updates
- **Gemini 2.5 Flash**: AI-powered plant identification and diagnosis

## 🔮 Roadmap

### Upcoming Features
- [ ] **Community Features**: Share plants and get help from other users
- [ ] **Plant Shopping**: Integration with plant stores and nurseries
- [ ] **Advanced Analytics**: Plant health trends and insights
- [ ] **AR Plant Care**: Augmented reality plant identification
- [ ] **Weather Integration**: Location-based care recommendations
- [ ] **Plant Propagation**: Guides for growing new plants
- [ ] **Disease Database**: Comprehensive plant disease encyclopedia

### Technical Improvements
- [ ] **Offline Mode**: Full offline functionality
- [ ] **Push Notifications**: Enhanced reminder system
- [ ] **Image Optimization**: Better image compression and caching
- [ ] **Performance**: App optimization and faster AI processing
- [ ] **Accessibility**: Improved accessibility features
- [ ] **Internationalization**: Multi-language support

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

### Code Standards
- Follow Flutter/Dart conventions
- Use provided linting rules
- Write meaningful commit messages
- Add documentation for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Google Gemini**: For AI-powered plant analysis
- **Supabase**: For backend infrastructure
- **Flutter Team**: For the amazing framework
- **Plant Community**: For inspiration and feedback

## 📞 Support

- **Documentation**: Check the [Wiki](../../wiki) for detailed guides
- **Issues**: Report bugs on [GitHub Issues](../../issues)
- **Discussions**: Join conversations in [GitHub Discussions](../../discussions)
- **Email**: support@plantpal.app

---

**Happy Gardening! 🌱✨**

Built with ❤️ by the PlantPal team 