import 'dart:io';
// ...existing imports
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:jagat_tani/services/image_preprocess.dart';

void main() {
  test('preprocess produces correct length and normalization', () {
    // create a small 10x10 red image
  final image = img.Image(width: 10, height: 10);
    for (int y = 0; y < 10; y++) {
      for (int x = 0; x < 10; x++) {
  image.setPixelRgba(x, y, 255, 0, 0, 255);
      }
    }
    final bytes = img.encodeJpg(image);
    final tmp = File('test_tmp.jpg');
    tmp.writeAsBytesSync(bytes);

  final input = preprocessImage(tmp.path, 10, 10);
    expect(input.length, equals(10 * 10 * 3));
    // red channel normalized to approx 1.0
    expect(input[0], closeTo(1.0, 0.01));

    tmp.deleteSync();
  });
}
