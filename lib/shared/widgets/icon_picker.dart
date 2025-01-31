import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

iconPicker(BuildContext context) async {
  IconData? icon =
      await showIconPicker(context, iconPackModes: [IconPack.material]);
}
