import 'dart:async';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../models/recipe.dart';
import 'timer_screen.dart';

class CookingModeScreen extends StatefulWidget {
  final Recipe recipe;

  const CookingModeScreen({super.key, required this.recipe});

  @override
  State<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends State<CookingModeScreen> {
  late StreamSubscription<dynamic> _streamSubscription;
  int _currentStep = 0;
  bool _isNear = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
        if (_isNear) {
          _nextStep();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    WakelockPlus.disable();
    _streamSubscription.cancel();
  }

  void _nextStep() {
    if (_currentStep < widget.recipe.steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.recipe.steps[_currentStep];
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              _previousStep();
            } else if (details.primaryVelocity! < 0) {
              _nextStep();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step ${_currentStep + 1} / ${widget.recipe.steps.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                        children: _buildTextSpans(step.instruction),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStep > 0)
                      ElevatedButton(
                        onPressed: _previousStep,
                        child: const Text('Previous'),
                      ),
                    if (_currentStep < widget.recipe.steps.length - 1)
                      ElevatedButton(
                        onPressed: _nextStep,
                        child: const Text('Next'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String text) {
    final List<TextSpan> spans = [];
    final RegExp regExp = RegExp(r'(\d+)\s*(minutes|minute)');
    
    regExp.allMatches(text).forEach((match) {
      final int minutes = int.parse(match.group(1)!);
      spans.add(
        TextSpan(
          text: text.substring(0, match.start),
        ),
      );
      spans.add(
        TextSpan(
          text: match.group(0),
          style: const TextStyle(
            color: Colors.orange,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimerScreen(durationInMinutes: minutes),
                ),
              );
            },
        ),
      );
      text = text.substring(match.end);
    });

    spans.add(TextSpan(text: text));

    return spans;
  }
}