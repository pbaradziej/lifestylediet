import 'package:flutter/material.dart';
import 'package:lifestylediet/styles/app_text_styles.dart';

class SnackBarBuilder {
  static void showSnackBar(BuildContext buildContext, String message) {
    ScaffoldMessenger.of(buildContext).showSnackBar(
      _buildSnackBar(buildContext, message),
    );
  }

  static SnackBar _buildSnackBar(BuildContext buildContext, String message) {
    final ColorScheme colorScheme = Theme.of(buildContext).colorScheme;
    return SnackBar(
      content: _snackBarText(
        context: buildContext,
        message: message,
      ),
      duration: const Duration(seconds: 7),
      behavior: SnackBarBehavior.floating,
      backgroundColor: colorScheme.background,
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
        textColor: colorScheme.onSurface,
      ),
    );
  }

  static Widget _snackBarText({
    required BuildContext context,
    required String message,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Text(
      message,
      style: AppTextStyle.bodyMedium(context)?.copyWith(
        color: colorScheme.onBackground,
      ),
    );
  }
}
