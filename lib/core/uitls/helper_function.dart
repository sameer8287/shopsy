import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HelperFunctions {
  static printLog(String tag, dynamic message) {
    if (kDebugMode) {
      log('$tag: $message');
    }
  }

  static showSnackBar(BuildContext context, String text, {Color? color = Colors.black, Duration duration = const Duration(milliseconds: 4000)}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), backgroundColor: color, duration: duration));
  }
}
