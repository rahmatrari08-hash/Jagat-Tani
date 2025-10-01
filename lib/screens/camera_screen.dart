import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'result_screen.dart';
import '../widgets/large_action_button.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    try {
      // Check camera permission
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Izin kamera diperlukan')));
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kamera tidak tersedia')));
        return;
      }

      final firstCamera = cameras.first;
      _controller = CameraController(firstCamera, ResolutionPreset.high);
      _initializeControllerFuture = _controller.initialize();
      await _initializeControllerFuture;
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal inisialisasi kamera: $e')));
    }
  }

  // Ambil gambar dari kamera
  Future<void> _takePicture() async {
    await _initializeControllerFuture;
    final image = await _controller.takePicture();
    setState(() {
      _image = image;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Photo Captured')));
    // Navigate to result screen to run prediction
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(imagePath: image.path)),
    );
  }

  // Ambil gambar dari galeri
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image selected from gallery')));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(imagePath: pickedFile.path)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ambil Gambar Daun Padi')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _controller.value.isInitialized
                  ? CameraPreview(_controller)
                  : CircularProgressIndicator(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                LargeActionButton(
                  icon: Icons.camera_alt,
                  label: 'Ambil Gambar',
                  onPressed: _takePicture,
                ),
                const SizedBox(height: 12),
                LargeActionButton(
                  icon: Icons.photo_library,
                  label: 'Pilih dari Galeri',
                  onPressed: _pickImage,
                  color: Colors.brown,
                ),
                const SizedBox(height: 12),
                if (_image != null) Image.file(File(_image!.path), height: 120),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    try {
      _controller.dispose();
    } catch (_) {}
  }
}
