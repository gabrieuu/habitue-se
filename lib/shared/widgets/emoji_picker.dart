import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habitue_se/shared/temas.dart';

void emojiSelector(
    {required BuildContext context,
    TextEditingController? textEditingController,
    ScrollController? scrollController}) {
  showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return EmojiPicker(
          config: Config(
              height: MediaQuery.of(context).size.height * 0.4,
              categoryViewConfig: const CategoryViewConfig(
                initCategory: Category.ACTIVITIES,
              ),
              bottomActionBarConfig: BottomActionBarConfig(
                  backgroundColor: Temas.primary, buttonColor: Temas.primary)),
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
