import 'package:flutter/material.dart';
import 'package:refreshi_test/bootstrap/theme/theme_extensions/util_extensions.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/domain/entities/catalog_item.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/checkout_pane.dart';
import 'package:refreshi_test/presentation/shared/view_model_extensions/cart_item_extension.dart';
import 'package:refreshi_test/presentation/shared/format_rand.dart';

part 'cart_item_card.dart';

class CartPanel extends StatelessWidget {
  const CartPanel({
    required this.items,
    required this.catalogItems,
    this.expand = true,
    this.onRemove,
    super.key,
  });

  final List<CartItemEntity> items;
  final List<CatalogItemEntity> catalogItems;
  final bool expand;
  final ValueChanged<CartItemEntity>? onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;
    final lines = items.active.toList();

    final list = lines.isEmpty
        ? Text(
            'Cart is empty',
            style: type.bodyMedium.copyWith(color: colors.onSurface),
          )
        : ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: !expand,
            physics: expand ? null : const NeverScrollableScrollPhysics(),
            itemCount: lines.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = lines[index];
              final catalog = item.catalogItem(catalogItems);
              if (catalog == null) {
                return const SizedBox.shrink();
              }
              return CartItemCard(
                item: item,
                catalog: catalog,
                onRemove: onRemove == null ? null : () => onRemove!(item),
              );
            },
          );

    return CheckoutPane(
      title: 'Cart',
      expand: expand,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (expand) Expanded(child: list) else list,
          DecoratedBox(
            key: const Key('cart-totals'),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: colors.onSurface.withValues(alpha: 0.28)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 12),
              child: Row(
                children: [
                  Text(
                    'Total',
                    style: type.titleMedium.copyWith(color: colors.onBackground),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      formatRand(items.totalCents(catalogItems)),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: type.titleMedium.copyWith(
                        color: colors.onBackground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
