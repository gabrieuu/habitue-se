import 'package:flutter/material.dart';
import 'package:habitue_se/shared/temas.dart';

extension ExtensionColor on Color {
  String get colorToHexString {
    final red = (this.red).toRadixString(16).padLeft(2, '0');
    final green = (this.green).toRadixString(16).padLeft(2, '0');
    final blue = (this.blue).toRadixString(16).padLeft(2, '0');
    final alpha = (this.alpha).toRadixString(16).padLeft(2, '0');
    return '#$alpha$red$green$blue';
  }
}

Color hexToColor(String hexColor) {
  hexColor = hexColor.replaceAll('#', '');

  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor'; // Assume 100% opacidade (FF) se não houver alfa
  }

  return Color(int.parse('0x$hexColor'));
}

Color percentColor(double percent) {
  // if (percent < 0.3) {
  //   return Colors.red;
  // }
  // if (percent < 0.5) {
  //   return Colors.orange;
  // }
  // if (percent < 0.7) {
  //   return Colors.yellow;
  // }
  if (percent < 1.0) {
    return Temas.primary;
  }
  return Colors.green;
}
