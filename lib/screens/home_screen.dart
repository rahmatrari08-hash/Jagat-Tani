import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'weather_screen.dart';
import '../widgets/large_action_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Jagat Tani'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Google Sign-in placeholder
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final googleUser = await GoogleSignIn().signIn();
                    if (googleUser == null) return; // user cancelled
                    final googleAuth = await googleUser.authentication;
                    final credential = GoogleAuthProvider.credential(
                      accessToken: googleAuth.accessToken,
                      idToken: googleAuth.idToken,
                    );
                    await FirebaseAuth.instance.signInWithCredential(credential);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil masuk')));
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal masuk: $e')));
                  }
                },
                icon: Icon(Icons.login),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(user != null ? 'Halo, ${user.displayName}' : 'Masuk dengan Google', style: theme.textTheme.titleLarge),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: theme.primaryColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

              const SizedBox(height: 24),

              // Main actions
              LargeActionButton(
                icon: Icons.camera_alt,
                label: 'Scan Daun (Deteksi Penyakit)',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraScreen()),
                  );
                },
                color: theme.primaryColor,
              ),

              const SizedBox(height: 16),

              LargeActionButton(
                icon: Icons.cloud,
                label: 'Dapatkan Rekomendasi & Cuaca',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WeatherScreen()),
                  );
                },
                color: Color(0xFF03A9F4),
              ),

              const SizedBox(height: 24),

              // Dashboard summary placeholder
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.history, size: 36, color: theme.primaryColor),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Diagnosis Terakhir', style: theme.textTheme.titleLarge),
                                  SizedBox(height: 6),
                                  Text('Belum ada diagnosis', style: theme.textTheme.bodyMedium),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
