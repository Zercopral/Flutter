import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text("Icon and Photos"),
            leading: Image.asset('assets/media/appIcon.png')),
        body: Center(
            child: Wrap(
          children: [
            Image.asset('assets/media/photo1.png', width: 200, height: 200),
            Image.asset('assets/media/photo2.png', width: 200, height: 200),
            Image.asset('assets/media/photo3.png', width: 200, height: 200),
            Image.asset('assets/media/photo4.png', width: 200, height: 200),
          ],
        )),
      ),
    );
  }
}
