import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class RaspService {
  static final RaspService _instance = RaspService._internal();

  factory RaspService() {
    return _instance;
  }

  RaspService._internal();

  Future<bool> isJailbroken() async {
    try {
      return await FlutterJailbreakDetection.jailbroken;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> isDeveloperMode() async {
    try {
      return await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      return false;
    }
  }
}