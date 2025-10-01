import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';

class MLService {
  late Interpreter _interpreter;

  // Load model TFLite
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('models/paddy_leaf.tflite');
      print("Model loaded successfully.");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  // Preprocess gambar dan lakukan inferensi
  Future<Map<String, dynamic>> detectDisease(String imagePath) async {
    // Placeholder untuk proses preprocessing dan inferensi
    var image = File(imagePath);  // Gambar yang dipilih
    // Preprocess gambar, resize dan normalisasi sesuai input model

    // Contoh: memuat gambar, resize, dan normalisasi (ini hanya placeholder)
    var input = image.readAsBytesSync();  // Placeholder, perlu preprocessing
    var output = List.generate(1, (index) => List.filled(4, 0.0));  // 4 label output
    
    // Jalankan inferensi menggunakan model TFLite
    _interpreter.run(input, output);

    // Mapping output ke label
    var label = _getLabel(output);
    var confidence = output[0].reduce((value, element) => value > element ? value : element);

    return {
      'label': label,
      'confidence': confidence
    };
  }

  // Menerjemahkan output ke label
  String _getLabel(List output) {
    if (output[0][0] > 0.5) return 'Sehat';
    if (output[0][1] > 0.5) return 'Blas';
    if (output[0][2] > 0.5) return 'Hawar Bakteri';
    return 'Bercak Coklat';
  }
}
