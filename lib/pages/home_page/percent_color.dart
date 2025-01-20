import 'dart:ui';

import 'package:flutter/material.dart';

Color percentColor(double percent) {
  if (percent < 0.3) {
    return Colors.red;
  }
  if (percent < 0.5) {
    return Colors.orange;
  }
  if (percent < 0.7) {
    return const Color.fromARGB(255, 255, 230, 0);
  }
  if (percent < 1.0) {
    return Colors.blue;
  }
  return Colors.green;
}
