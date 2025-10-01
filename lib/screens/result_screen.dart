import 'package:flutter/material.dart';
import '../services/ml_service.dart';

class ResultScreen extends StatefulWidget {
  final String imagePath;

  const ResultScreen({super.key, required this.imagePath});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String _prediction = 'Menunggu Prediksi...';
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _getPrediction();
  }

  void _getPrediction() async {
    MLService mlService = MLService();
    await mlService.loadModel();
    var result = await mlService.detectDisease(widget.imagePath);
    setState(() {
      _prediction = result['label'];
      _confidence = (result['confidence'] is double) ? result['confidence'] : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Prediksi Penyakit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Diagnosis', style: theme.textTheme.titleLarge),
                    SizedBox(height: 8),
                    Text(_prediction, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Confidence: ${(_confidence * 100).toStringAsFixed(2)}%', style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Perawatan & Pencegahan', style: theme.textTheme.titleLarge),
                    SizedBox(height: 8),
                    Text('- Periksa tanaman secara berkala', style: theme.textTheme.bodyMedium),
                    SizedBox(height: 6),
                    Text('- Gunakan fungisida sesuai anjuran (jika penyakit jamur)', style: theme.textTheme.bodyMedium),
                    SizedBox(height: 6),
                    Text('- Jaga kelembaban tanah dan sirkulasi udara', style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text('Kembali', style: theme.textTheme.titleLarge),
              ),
            )
          ],
        ),
      ),
    );
  }
}
