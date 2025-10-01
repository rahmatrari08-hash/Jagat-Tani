# Jagat Tani

A Flutter app for Indonesian rice farmers.

Setup notes (models, Firebase, and API keys)

- Models: place your TFLite models in `assets/models/`:
	- `assets/models/paddy_leaf.tflite` (disease detection)
	- `assets/models/fertilizer_recommender.tflite` (fertilizer recommendation)
	After adding, run `flutter pub get`.

- Firebase: run `flutterfire configure` locally to generate `lib/firebase_options.dart` and platform config files (`google-services.json`, `GoogleService-Info.plist`).

- API keys: create a `.env` file at project root and add `OPENWEATHER_API_KEY=your_key_here`. Call `await dotenv.load()` in `main()` before using the weather service.

After these steps you can run `flutter run` to test the app.
# jagat_tani

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
