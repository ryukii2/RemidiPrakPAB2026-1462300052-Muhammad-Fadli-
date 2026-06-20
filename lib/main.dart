import 'package:flutter/material.dart';
//import 'package:flutter_pertemuan1/Page1.dart';
//import 'package:flutter_pertemuan1/Page1.dart';
//mport 'package:flutter_pertemuan1/SplashScreen.dart';
//import 'package:flutter_pertemuan1/daftar.dart';
//import 'package:flutter_pertemuan1/registerScreen.dart';
import 'package:flutter_pertemuan1/splashscreen.dart';
//import 'package:flutter_pertemuan1/PinScreen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Splashscreen());
  }
}
