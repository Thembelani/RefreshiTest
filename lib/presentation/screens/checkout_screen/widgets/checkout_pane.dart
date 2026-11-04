import 'package:flutter/material.dart';
import 'package:refreshi_test/bootstrap/theme/theme_extensions/util_extensions.dart';

class CheckoutPane extends StatelessWidget {
  const CheckoutPane({
    required this.title,
    required this.child,
    this.expand = true,
    super.key,
  });

  final String title;
  final Widget child;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;

    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.onSurface.withValues(alpha: 0.28)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Text(
              title,
              style: type.headlineSmall.copyWith(color: colors.onBackground),
            ),
            const SizedBox(height: 12),
            if (expand) Expanded(child: child) else child,
          ],
        ),
      ),
    );
  }
}
