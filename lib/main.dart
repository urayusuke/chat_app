import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final initialRoute = window.defaultRouteName;
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final channel = const MethodChannel('com.example.openwebpage');

  const HomeScreen({super.key});

  void openWebPage(String url) async {
    await channel.invokeMethod('openWebPage', url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            openWebPage('https://chat.openai.com/'); // ここで関数を呼び出す
          },
          child: const Text('Open WebView'),
        ),
      ),
    );
  }
}

