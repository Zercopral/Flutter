import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MVVM')),
      body: EntityStateNotifierBuilder<int>(
        listenableEntityState: CounterModel().counterState,
        builder: (context, count) {
          return Center(
            child: Text('Count: $count'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CounterModel().incrementCounter();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CounterModel extends ElementaryModel {
  final _counterState = EntityStateNotifier<int>(0);

  EntityStateNotifier<int> get counterState => _counterState;

  void incrementCounter() {
    final currentCount = _counterState.value;
    print(currentCount);
    _counterState.content(currentCount + 1);
  }
}
