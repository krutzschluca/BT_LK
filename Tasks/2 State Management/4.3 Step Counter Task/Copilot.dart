import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StepCounterProvider with ChangeNotifier {
  int _stepCount = 0;
  DateTime _lastResetTime = DateTime.now();

  int get stepCount => _stepCount;

  StepCounterProvider() {
    _resetStepCountAtMidnight();
  }

  void incrementStepCount() {
    _stepCount++;
    notifyListeners();
  }

  void _resetStepCountAtMidnight() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = midnight.difference(now);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(durationUntilMidnight, () {
        _stepCount = 0;
        _lastResetTime = DateTime.now();
        notifyListeners();
        _resetStepCountAtMidnight();
      });
    });
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StepCounterProvider(),
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Step Counter App'),
          ),
        ),
      ),
    );
  }
}