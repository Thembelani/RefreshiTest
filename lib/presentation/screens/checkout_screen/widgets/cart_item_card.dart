part of 'cart_panel.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    required this.item,
    required this.catalog,
    this.onRemove,
    super.key,
  });

  final CartItemEntity item;
  final CatalogItemEntity catalog;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;

    return Material(
      color: colors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.onSurface.withValues(alpha: 0.28)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    catalog.name,
                    overflow: TextOverflow.ellipsis,
                    style: type.titleMedium.copyWith(color: colors.onBackground),
                  ),
                ),
                if (onRemove != null)
                  IconButton(
                    key: Key('cart-remove-${catalog.id}'),
                    tooltip: 'Remove item',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    visualDensity: VisualDensity.compact,
                    iconSize: 20,
                    icon: Icon(Icons.delete_outline, color: colors.primary),
                    onPressed: onRemove,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              item.summary(catalog),
              style: type.bodyMedium.copyWith(color: colors.onSurface),
            ),
            const SizedBox(height: 4),
            Text(
              'Qty ${item.quantity}',
              style: type.bodyMedium.copyWith(color: colors.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
