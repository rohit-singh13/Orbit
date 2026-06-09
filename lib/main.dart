import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:orbit/configuration/dependency_injection.dart';
import 'package:provider/provider.dart';
import 'package:orbit/firebase_options.dart';
import 'app.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: DependencyInjection.providers,
      child: const MyApp(),
    ),
  );
}