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
 
Figma integration and exporting assets

1) Export assets from Figma:
	- Open your Figma file and select frames/components you want to export.
	- In the right panel, under "Export", set export formats for images (PNG/JPG) or SVG for vector icons.
	- For icons prefer SVG; for photos prefer JPEG/PNG.
	- Click "Export" and save assets locally.

2) Use Figma plugins to help with Flutter code:
	- Install the "Figma to Flutter" plugin or "Flutter Export" in Figma.
	- These plugins can generate Dart/Flutter code snippets for layouts and components.
	- Note: generated code often requires manual cleanup to match your project's architecture.

3) Organize assets in the project:
	- Place exported raster images in `assets/images/` and SVG/icon files in `assets/icons/`.
	- Update `pubspec.yaml` to reference any new asset folders, then run `flutter pub get`.

4) Open and sync in Figma:
	- To open the design in the Figma desktop app, use "File -> Open" and choose your Figma file or open the Figma URL in the desktop app.
	- If you want to share assets across team, publish components to a Figma Team Library and download exported assets on your dev machine.

5) Committing exported code/assets:
	- Add assets to the `assets/` folder and commit them to Git.
	- If you used Figma-to-Flutter code, place generated widgets in `lib/widgets/` or a `lib/design/` folder and review/clean the code before committing.

If you want, I can:
- Add a small shell of generated widgets under `lib/design/` using a Figma export you provide.
- Add scripts or README commands to automate copying assets from a provided export folder into `assets/`.
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
