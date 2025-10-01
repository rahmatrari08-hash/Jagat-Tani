import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jagat_tani/screens/result_screen.dart';

void main() {
  testWidgets('ResultScreen shows loading then success', (tester) async {
    Future<Map<String, dynamic>> fakeDetect(String path) async {
      await Future.delayed(Duration(milliseconds: 50));
      return {'label': 'Sehat', 'confidence': 0.95};
    }

    await tester.pumpWidget(MaterialApp(home: ResultScreen(imagePath: 'x', detectFn: fakeDetect)));
    // initial loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    // after detection, diagnosis shown
    expect(find.text('Sehat'), findsOneWidget);
    expect(find.textContaining('Confidence'), findsOneWidget);
  });

  testWidgets('ResultScreen handles failure', (tester) async {
    Future<Map<String, dynamic>> fakeDetectFail(String path) async {
      await Future.delayed(Duration(milliseconds: 20));
      throw Exception('model error');
    }

    await tester.pumpWidget(MaterialApp(home: ResultScreen(imagePath: 'x', detectFn: fakeDetectFail)));
    await tester.pumpAndSettle();
    expect(find.textContaining('Error'), findsOneWidget);
  });
}
