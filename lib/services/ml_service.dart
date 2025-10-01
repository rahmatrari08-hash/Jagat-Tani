import 'dart:io';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class MLService {
  Interpreter? _interpreter;
  String? _modelAsset;

  /// Load a tflite model from assets (e.g., 'assets/models/paddy_leaf.tflite')
  Future<void> loadModel(String assetPath) async {
    try {
      _interpreter = await Interpreter.fromAsset(assetPath.replaceFirst('assets/', ''));
      _modelAsset = assetPath;
      print('Model $assetPath loaded.');
    } catch (e) {
      print('Error loading model $assetPath: $e');
      rethrow;
    }
  }

  /// Run inference for disease detection. Returns label and confidence.
  Future<Map<String, dynamic>> detectDisease(String imagePath) async {
    if (_interpreter == null) {
      await loadModel('assets/models/paddy_leaf.tflite');
    }

    // Typical model input size; adjust to your model's expected size
    const int inputSize = 224;

  final input = _preprocess(imagePath, inputSize, inputSize);

  // Assuming model outputs a 1 x 4 array of confidences
  final output = List.filled(4, 0.0).reshape([1, 4]);

  // interpreter expects input as List or typed buffer shaped [1, h, w, 3]
  _interpreter!.run([input], output);

  // convert output to list
  List<double> confidences = List<double>.from(output[0].map((e) => (e as num).toDouble()));

    final maxIdx = confidences.indexWhere((c) => c == confidences.reduce((a, b) => a > b ? a : b));
    final confidence = confidences[maxIdx];
    final label = _diseaseLabel(maxIdx);

    return {'label': label, 'confidence': confidence};
  }

  /// Generic fertilizer recommender (placeholder) using second model
  Future<Map<String, dynamic>> recommendFertilizer(String imagePath) async {
    if (_interpreter == null || _modelAsset?.contains('fertilizer') != true) {
      await loadModel('assets/models/fertilizer_recommender.tflite');
    }

    const int inputSize = 224;
  final input = _preprocess(imagePath, inputSize, inputSize);

  // assuming output size 1 x 3 (example)
  final output = List.filled(3, 0.0).reshape([1, 3]);
  _interpreter!.run([input], output);
  List<double> confidences = List<double>.from(output[0].map((e) => (e as num).toDouble()));
    final maxIdx = confidences.indexWhere((c) => c == confidences.reduce((a, b) => a > b ? a : b));
    final confidence = confidences[maxIdx];
    final label = _fertilizerLabel(maxIdx);
    return {'label': label, 'confidence': confidence};
  }

  /// Preprocess image: load, resize and normalize to Float32List
  /// Returns a Float32List shaped [1, height, width, 3]
  Float32List _preprocess(String imagePath, int width, int height) {
    final file = File(imagePath);
    final bytes = file.readAsBytesSync();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception('Could not decode image');
    final resized = img.copyResize(image, width: width, height: height);

    final input = Float32List(width * height * 3);
    int offset = 0;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = resized.getPixel(x, y);
        // Pixel object provides r, g, b properties in newer image versions
        final r = pixel.r / 255.0;
        final g = pixel.g / 255.0;
        final b = pixel.b / 255.0;
        input[offset++] = r;
        input[offset++] = g;
        input[offset++] = b;
      }
    }

    return input;
  }

  String _diseaseLabel(int idx) {
    // Replace with real labels matching your model's output order
    const labels = ['Sehat', 'Blas', 'Hawar Bakteri', 'Bercak Coklat'];
    return labels[idx.clamp(0, labels.length - 1)];
  }

  String _fertilizerLabel(int idx) {
    const labels = ['Urea', 'SP-36', 'KCl'];
    return labels[idx.clamp(0, labels.length - 1)];
  }
}
