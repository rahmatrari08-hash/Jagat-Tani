import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as developer;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'image_preprocess.dart';

class MLService {
  Interpreter? _interpreter;
  String? _modelAsset;

  /// Load a tflite model from assets (e.g., 'assets/models/paddy_leaf.tflite')
  Future<void> loadModel(String assetPath) async {
    try {
      _interpreter = await Interpreter.fromAsset(assetPath.replaceFirst('assets/', ''));
      _modelAsset = assetPath;
      developer.log('Model $assetPath loaded.', name: 'MLService');
    } catch (e) {
      developer.log('Error loading model $assetPath: $e', name: 'MLService', level: 1000);
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

  final input = preprocess(imagePath, inputSize, inputSize);

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
  final input = preprocess(imagePath, inputSize, inputSize);

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
  /// Public helper for tests. Returns a Float32List shaped [height * width * 3]
  Float32List preprocess(String imagePath, int width, int height) {
    return preprocessImage(imagePath, width, height);
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
