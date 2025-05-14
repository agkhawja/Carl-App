// ignore_for_file: avoid_print

import 'package:carl/home_screens/home_main_screen.dart';
import 'package:carl/splash_screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await _requestMicrophonePermission(); // Request permission at startup
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn =
      prefs.getString('jwt') != null && prefs.getString('user') != null;
  PermissionStatus status = await Permission.photos.status;
  if (!status.isGranted) {
    await Permission.photos.request();
  }
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<void> _requestMicrophonePermission() async {
  var status = await Permission.microphone.status;
  print('Initial microphone permission status in main: $status');
  if (!status.isGranted) {
    print('Requesting microphone permission in main...');
    status = await Permission.microphone.request();
    print('Permission request result in main: $status');
    if (status.isPermanentlyDenied) {
      print('Microphone permission permanently denied in main');
      // Note: We can't show a dialog here since no context is available yet
      // The CreateAccountScreen will handle this case later
    }
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Carl App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: isLoggedIn ? const HomeMainScreen() : const SplashScreen(),
        );
      },
    );
  }
}
