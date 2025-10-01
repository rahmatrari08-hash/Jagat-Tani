import 'dart:io';
import 'dart:developer' as developer;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static const _weatherBox = 'weather_box';
  static const _diagBox = 'diagnosis_box';
  static const _uploadBox = 'upload_box';

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
    await Hive.openBox(_weatherBox);
    await Hive.openBox(_diagBox);
    await Hive.openBox(_uploadBox);
    developer.log('Hive initialized at ${dir.path}', name: 'StorageService');
  }

  // Weather caching
  static Future<void> cacheWeather(String city, Map<String, dynamic> data) async {
    final box = Hive.box(_weatherBox);
    await box.put('last_weather_$city', data);
  }

  static Map<String, dynamic>? getCachedWeather(String city) {
    final box = Hive.box(_weatherBox);
    return box.get('last_weather_$city')?.cast<String, dynamic>();
  }

  // Diagnosis caching
  static Future<void> cacheDiagnosis(String id, Map<String, dynamic> data) async {
    final box = Hive.box(_diagBox);
    await box.put(id, data);
  }

  static List<Map<String, dynamic>> getAllDiagnoses() {
    final box = Hive.box(_diagBox);
    return box.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  // Upload queue for images (store local file paths)
  static Future<void> enqueueImageForUpload(String localPath) async {
    final box = Hive.box(_uploadBox);
    final queue = List<String>.from(box.get('queue', defaultValue: <String>[]) as List);
    queue.add(localPath);
    await box.put('queue', queue);
  }

  static List<String> getUploadQueue() {
    final box = Hive.box(_uploadBox);
    return List<String>.from(box.get('queue', defaultValue: <String>[]) as List);
  }

  static Future<void> uploadQueuedImages() async {
    final queue = getUploadQueue();
    if (queue.isEmpty) return;
    final newQueue = <String>[];
    final storage = FirebaseStorage.instance;
    for (final path in queue) {
      try {
        final file = File(path);
        if (!await file.exists()) continue;
        final ref = storage.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}');
        await ref.putFile(file);
        developer.log('Uploaded $path to Firebase Storage', name: 'StorageService');
      } catch (e) {
        developer.log('Failed to upload $path: $e', name: 'StorageService', level: 1000);
        newQueue.add(path);
      }
    }
    final box = Hive.box(_uploadBox);
    await box.put('queue', newQueue);
  }
}
