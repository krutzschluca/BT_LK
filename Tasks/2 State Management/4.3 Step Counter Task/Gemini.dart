import 'dart:async';

import 'package:flutter/material.dart';

// Define a StepCounter class to hold the step count state.
class StepCounter with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  // Method to increment the step count.
  void incrementStepCount() {
    _count++;
    notifyListeners();
  }

  // Method to reset the step count.
  void resetStepCount() {
    _count = 0;
    notifyListeners();
  }

  // Simulate step data for testing.
  void mockStepData() {
    // Generate a random number of steps every few seconds.
    Timer.periodic(const Duration(seconds: 5), (timer) {
      // Generate a random number between 1 and 10.
      int randomSteps = (DateTime.now().millisecondsSinceEpoch % 10) + 1;
      _count += randomSteps;
      notifyListeners();
    });
  }

  // Reset the step count at midnight.
  void resetAtMidnight() {
    // Calculate the time remaining until midnight.
    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day + 1);
    Duration timeUntilMidnight = midnight.difference(now);

    // Schedule a timer to reset the step count at midnight.
    Timer(timeUntilMidnight, () {
      resetStepCount();

      // Recursively call this method to reset the count every day.
      resetAtMidnight();
    });
  }
}

void main() {
  // Create an instance of the StepCounter.
  StepCounter stepCounter = StepCounter();

  // Start mocking step data.
  stepCounter.mockStepData();

  // Schedule the reset at midnight.
  stepCounter.resetAtMidnight();
}