import 'dart:async';

class StepCounter extends ChangeNotifier {
  int _stepCount = 0;
  late Timer _resetTimer;

  StepCounter() {
    _initializeResetTimer();
  }

  /// Get the current step count
  int get stepCount => _stepCount;

  /// Mock step increment (simulate detecting a step)
  void incrementStep() {
    _stepCount++;
    notifyListeners();
  }

  /// Resets the step count to zero
  void resetStepCount() {
    _stepCount = 0;
    notifyListeners();
  }

  /// Initialize a timer to reset step count at midnight
  void _initializeResetTimer() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = midnight.difference(now);

    _resetTimer = Timer(durationUntilMidnight, () {
      resetStepCount();
      _initializeResetTimer(); // Reinitialize timer for the next day
    });
  }

  /// Clean up resources (e.g., timers) when no longer needed
  @override
  void dispose() {
    _resetTimer.cancel();
    super.dispose();
  }
}

// Mock test script
void main() {
  final stepCounter = StepCounter();

  // Listen to changes in step count
  stepCounter.addListener(() {
    print("Current step count: ${stepCounter.stepCount}");
  });

  // Simulate steps being detected
  Timer.periodic(Duration(seconds: 1), (timer) {
    stepCounter.incrementStep();
    if (stepCounter.stepCount >= 10) {
      timer.cancel(); // Stop simulation after 10 steps
    }
  });
}
