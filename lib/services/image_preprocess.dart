import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Load image from path, resize and normalize into Float32List [width*height*3]
Float32List preprocessImage(String imagePath, int width, int height) {
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
