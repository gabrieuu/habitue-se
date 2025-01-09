import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void emoji_selector(
    {required BuildContext context,
    TextEditingController? textEditingController,
    ScrollController? scrollController}) {
  showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) {
        return EmojiPicker(
          textEditingController: textEditingController,
          scrollController: scrollController,
          onEmojiSelected: (category, emoji) {
            if (textEditingController != null) {
              textEditingController.text = emoji.emoji;
            }
          },
        );
      });
}
