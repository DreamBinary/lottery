import 'package:flutter/material.dart';
import 'package:lottery/static_page.dart';
import 'package:mmkv/mmkv.dart';

void main() async {
  final rootDir = await MMKV.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StaticPage(),
    );
  }
}
