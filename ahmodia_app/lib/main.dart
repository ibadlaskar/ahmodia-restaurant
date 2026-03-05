// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/cart_provider.dart';
import 'screens/screens.dart';
import 'services/firebase_service.dart';

// 🔴 IMPORTANT: Replace this with your actual Firebase config
// Get it from: Firebase Console → Project Settings → Your apps → Web app config
// Then paste the values below
const firebaseOptions = FirebaseOptions(
  apiKey:            'YOUR_API_KEY',
  appId:             'YOUR_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId:         'YOUR_PROJECT_ID',
  storageBucket:     'YOUR_STORAGE_BUCKET',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar styling
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Initialize Firebase
  await Firebase.initializeApp(options: firebaseOptions);

  runApp(const AhmodiaApp());
}

class AhmodiaApp extends StatelessWidget {
  const AhmodiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Ahmodia Restaurant',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const SplashScreen(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SPLASH SCREEN
// ─────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1200));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();

    // Navigate after splash
    Future.delayed(const Duration(seconds: 2), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (_) => const MainShell()));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.green,
    body: Center(child: FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              color: AppColors.saffron,
              borderRadius: BorderRadius.circular(28)),
            child: const Center(
              child: Text('🍛', style: TextStyle(fontSize: 52)))),
          const SizedBox(height: 20),
          Text('Ahmodia',
            style: AppTheme.theme.textTheme.displayLarge?.copyWith(
              color: AppColors.white, fontSize: 36)),
          const SizedBox(height: 4),
          Text('RESTAURANT',
            style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.white.withOpacity(0.6),
              letterSpacing: 4, fontSize: 12)),
          const SizedBox(height: 40),
          const CircularProgressIndicator(
            color: AppColors.saffron2, strokeWidth: 2),
        ]),
      ),
    )),
  );
}
