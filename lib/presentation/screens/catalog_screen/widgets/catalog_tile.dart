import 'package:flutter/material.dart';
import 'package:refreshi_test/bootstrap/theme/app_palette/app_colors_extension.dart';
import 'package:refreshi_test/bootstrap/theme/theme_extensions/util_extensions.dart';
import 'package:refreshi_test/presentation/screens/catalog_screen/catalog_item.dart';

class CatalogTile extends StatelessWidget {
  const CatalogTile({
    required this.item,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final CatalogItem item;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              const zoom = 1.18;
              final layoutWidth = constraints.maxWidth;
              final layoutHeight = layoutWidth * 707 / 1024;
              final imageWidth = layoutWidth * zoom;
              final imageHeight = layoutHeight * zoom;
              return ClipRect(
                child: SizedBox(
                  width: layoutWidth,
                  height: layoutHeight,
                  child: OverflowBox(
                    minWidth: imageWidth,
                    maxWidth: imageWidth,
                    minHeight: imageHeight,
                    maxHeight: imageHeight,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/product_placeholder.png',
                      width: imageWidth,
                      height: imageHeight,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              );
            },
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: type.titleMedium.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.priceLabel,
                    textAlign: TextAlign.center,
                    style: type.bodyMedium.copyWith(color: colors.onSurface),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: Row(
              children: [
                const Expanded(flex: 1, child: SizedBox.shrink()),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      _QuantityButton(
                        icon: Icons.remove,
                        onPressed: quantity > 0 ? onRemove : null,
                        colors: colors,
                      ),
                      Expanded(
                        child: Text(
                          '$quantity',
                          textAlign: TextAlign.center,
                          style: type.titleMedium.copyWith(
                            color: colors.onBackground,
                          ),
                        ),
                      ),
                      _QuantityButton(
                        icon: Icons.add,
                        onPressed: onAdd,
                        colors: colors,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onPressed,
    required this.colors,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final AppColorsThemeExtension colors;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        disabledBackgroundColor: colors.onSurface.withValues(alpha: 0.12),
        disabledForegroundColor: colors.onSurface,
        minimumSize: const Size(36, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
