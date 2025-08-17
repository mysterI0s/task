# Data Explorer - Flutter Task Management App

A modern, feature-rich Flutter application built with clean architecture principles, featuring product and recipe management with advanced filtering, search, and pagination capabilities.

## 🚀 Features

### Core Features
- **Multi-language Support**: English and Arabic localization
- **Dynamic Theme System**: Light/Dark themes with Material 3 dynamic colors
- **Responsive Design**: Optimized for various screen sizes
- **Offline Support**: Local data caching with Hive database
- **Pull-to-Refresh**: Swipe down to refresh data
- **Infinite Scrolling**: Pagination for large datasets

### Product Management
- **Product Catalog**: Browse products with detailed information
- **Advanced Search**: Real-time search functionality
- **Category Filtering**: Filter products by category
- **Sorting Options**: Sort by name, price, rating, etc.
- **Product Details**: Comprehensive product information view

### Recipe Management
- **Recipe Collection**: Browse and search recipes
- **Recipe Details**: Step-by-step instructions and ingredients
- **Recipe Search**: Find recipes by ingredients or name
- **Settings Management**: User preferences and app configuration

### Technical Features
- **Clean Architecture**: Domain-driven design with clear separation of concerns
- **State Management**: Riverpod for reactive state management
- **API Integration**: RESTful API integration with Dio HTTP client
- **Code Generation**: Freezed, JSON serialization, and Retrofit
- **Error Handling**: Comprehensive error handling and user feedback
- **Performance**: Optimized with lazy loading and efficient data structures

## 🏗️ Architecture

The project follows Clean Architecture principles with a feature-based folder structure:

```
lib/
├── core/                    # Core functionality
│   ├── config/             # App configuration
│   ├── error/              # Error handling
│   ├── localization/       # Internationalization
│   ├── providers/          # Global providers
│   ├── router/             # Navigation routing
│   ├── theme/              # App theming
│   └── widgets/            # Reusable widgets
├── features/               # Feature modules
│   ├── main/              # Main screen
│   ├── products/          # Product management
│   │   ├── application/   # Business logic
│   │   ├── data/          # Data layer
│   │   ├── domain/        # Domain entities
│   │   └── presentation/  # UI layer
│   ├── recipes/           # Recipe management
│   └── splash/            # Splash screen
└── main.dart              # App entry point
```

### Architecture Layers
- **Presentation Layer**: UI components and state management
- **Application Layer**: Business logic and use cases
- **Domain Layer**: Entities, repositories, and business rules
- **Data Layer**: API services, local storage, and data sources

## 🛠️ Tech Stack

### Core Dependencies
- **Flutter**: 3.8.1+ (SDK)
- **Dart**: Latest stable version
- **Riverpod**: State management and dependency injection
- **GoRouter**: Declarative routing solution

### Data & Networking
- **Dio**: HTTP client for API requests
- **Retrofit**: Type-safe HTTP client code generation
- **Hive**: Lightweight local database
- **SharedPreferences**: Key-value storage

### UI & UX
- **Material 3**: Latest Material Design components
- **Dynamic Color**: Adaptive theming based on system colors
- **Shimmer**: Loading placeholders
- **Pull to Refresh**: Swipe refresh functionality

### Code Generation
- **Freezed**: Immutable data classes
- **JSON Serializable**: JSON serialization
- **Retrofit Generator**: API client generation
- **Riverpod Generator**: Provider code generation

## 📱 Screenshots

The app includes the following main screens:
- **Splash Screen**: App initialization and branding
- **Main Screen**: Navigation hub
- **Products Screen**: Product catalog with search and filters
- **Product Details**: Detailed product information
- **Recipes Screen**: Recipe collection
- **Recipe Details**: Recipe instructions and ingredients
- **Settings Screen**: App configuration and preferences

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: 3.8.1 or higher
- **Dart SDK**: Latest stable version
- **Android Studio** / **VS Code**: IDE with Flutter extensions
- **Git**: Version control system

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/mysterI0s/task
   cd task
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (required for first run)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

1. **Enable code generation watch mode** (optional, for development)
   ```bash
   flutter packages pub run build_runner watch --delete-conflicting-outputs
   ```

2. **Run tests**
   ```bash
   flutter test
   ```

3. **Analyze code**
   ```bash
   flutter analyze
   ```

## 🔧 Configuration

### Environment Variables
The app supports environment-specific configuration:
- **API_KEY**: External API authentication (if required)
- **Base URL**: Currently configured to use dummyjson.com

### App Configuration
Key configuration options in `lib/core/config/app_config.dart`:
- **API Timeouts**: Connection, receive, and send timeouts
- **Pagination**: Default and maximum page sizes
- **Cache**: Expiration duration and storage keys
- **Storage**: Theme, locale, and onboarding preferences

## 📱 Platform Support

- **Android**: API level 21+ (Android 5.0+)
- **iOS**: iOS 12.0+
- **Web**: Modern browsers (Chrome, Firefox, Safari, Edge)
- **Desktop**: Windows, macOS, Linux (Flutter desktop support)

## 🧪 Testing

The project includes comprehensive testing setup:
- **Unit Tests**: Business logic and utilities
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end functionality

Run tests with:
```bash
flutter test
```

## 📦 Building for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🔍 Troubleshooting

### Common Issues

1. **Code Generation Errors**
   - Run `flutter packages pub run build_runner build --delete-conflicting-outputs`
   - Ensure all dependencies are properly installed

2. **Build Failures**
   - Clean build: `flutter clean && flutter pub get`
   - Check Flutter version compatibility

3. **API Connection Issues**
   - Verify internet connectivity
   - Check API endpoint availability
   - Review network configuration in `app_config.dart`

### Performance Optimization
- Use `flutter run --profile` for performance testing
- Monitor memory usage and CPU performance
- Implement lazy loading for large datasets

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit changes: `git commit -am 'Add feature'`
4. Push to branch: `git push origin feature-name`
5. Submit a pull request

### Code Style
- Follow Flutter/Dart style guidelines
- Use meaningful variable and function names
- Add comprehensive documentation
- Include tests for new features

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod for state management solutions
- All package contributors for their excellent libraries

## 📞 Support

For support and questions:
- Create an issue in the repository
- Check the Flutter documentation
- Review the code comments and documentation

---

**Happy Coding! 🎉**
