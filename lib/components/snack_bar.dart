import 'package:flutter/material.dart';
import 'package:lifestylediet/styles/app_text_styles.dart';

class SnackBarBuilder {
  static void showSnackBar(final BuildContext buildContext, final String message) {
    ScaffoldMessenger.of(buildContext).showSnackBar(
      _buildSnackBar(buildContext, message),
    );
  }

  static SnackBar _buildSnackBar(final BuildContext buildContext, final String message) {
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
    required final BuildContext context,
    required final String message,
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
