import 'package:adblocker_webview/adblocker_webview.dart';
import 'package:cinemanic/firebase_options.dart';
import 'package:cinemanic/utils/auth_gate.dart';
import 'package:cinemanic/utils/constants.dart';
import 'package:cinemanic/utils/notifiers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AdBlockerWebviewController.instance.initialize(
    FilterConfig(filterTypes: [FilterType.easyList, FilterType.adGuard]),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    loadThemeMode();
    super.initState();
  }

  void loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Load the initial value
    isDarkNotifier.value = prefs.getBool(isDarkKey) ?? true;

    // 2. Add a listener to save the value whenever it changes
    isDarkNotifier.addListener(() {
      prefs.setBool(isDarkKey, isDarkNotifier.value);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkNotifier,
      builder: (context, isDark, child) {
        return MaterialApp(
          title: 'Cinemanic',
          theme: ThemeData(
            colorScheme: .fromSeed(
              seedColor: Colors.blue,
              brightness: isDark ? Brightness.dark : Brightness.light,
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: AuthGate(),
        );
      },
    );
  }
}
