import 'package:flutter/material.dart';

import '../../../Core/Config/Theme/app_colors.dart';

class TextWithIconAndDivider extends StatelessWidget {
  final String text;
  final VoidCallback? onIconPressed;

  const TextWithIconAndDivider({
    Key? key,
    required this.text,
    this.onIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.labelGrey,
                  fontFamily: 'Roboto',
                ),
                overflow: TextOverflow.visible, // Ensures text doesn't get truncated
                softWrap: true,                // Allows text to wrap to the next line
                maxLines: null,                // Removes the limit on lines (optional)
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: onIconPressed,
              color: AppColors.primary,
            ),
          ],
        ),
        Divider(
          color: Colors.grey.shade400,
          thickness: 1,
        ),
      ],
    );
  }
}
