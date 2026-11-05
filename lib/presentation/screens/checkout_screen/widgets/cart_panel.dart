import 'package:flutter/material.dart';
import 'package:refreshi_test/bootstrap/theme/theme_extensions/util_extensions.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/domain/entities/catalog_item.dart';
import 'package:refreshi_test/shared/format_rand.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/catalog_service.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/checkout_pane.dart';

class CartLine {
  const CartLine({
    required this.cartItemId,
    required this.service,
    required this.quantity,
    required this.priceCents,
  });

  final int cartItemId;
  final CatalogService service;
  final int quantity;
  final int priceCents;
}

List<CartLine> cartLinesFrom({
  required List<CartItemEntity> items,
  required List<CatalogItemEntity> catalogItems,
}) {
  final lines = <CartLine>[];
  for (final item in items) {
    if (item.deletedAt != null || item.quantity <= 0) {
      continue;
    }
    CatalogItemEntity? catalog;
    for (final candidate in catalogItems) {
      if (candidate.id == item.catalogItemId) {
        catalog = candidate;
        break;
      }
    }
    if (catalog == null) {
      continue;
    }
    final priceCents = sellingPriceToCents(catalog.sellingPrice);
    lines.add(
      CartLine(
        cartItemId: item.id,
        service: CatalogService(
          id: '${catalog.id}',
          name: catalog.name,
          summary: formatRand(priceCents),
          icon: Icons.coffee_outlined,
        ),
        quantity: item.quantity,
        priceCents: priceCents,
      ),
    );
  }
  return lines;
}

int cartTotalCents(List<CartLine> lines) {
  return lines.fold(
    0,
    (total, line) => total + line.priceCents * line.quantity,
  );
}

class CartPanel extends StatelessWidget {
  const CartPanel({
    required this.lines,
    this.expand = true,
    this.onRemove,
    super.key,
  });

  final List<CartLine> lines;
  final bool expand;
  final ValueChanged<CartLine>? onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;

    final items = lines.isEmpty
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
            itemBuilder: (context, index) => CartItemCard(
              line: lines[index],
              onRemove: onRemove == null
                  ? null
                  : () => onRemove!(lines[index]),
            ),
          );

    return CheckoutPane(
      title: 'Cart',
      expand: expand,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (expand) Expanded(child: items) else items,
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
                      formatRand(cartTotalCents(lines)),
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

class CartItemCard extends StatelessWidget {
  const CartItemCard({required this.line, this.onRemove, super.key});

  final CartLine line;
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
                    line.service.name,
                    overflow: TextOverflow.ellipsis,
                    style: type.titleMedium.copyWith(color: colors.onBackground),
                  ),
                ),
                if (onRemove != null)
                  IconButton(
                    key: Key('cart-remove-${line.service.id}'),
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
              line.service.summary,
              style: type.bodyMedium.copyWith(color: colors.onSurface),
            ),
            const SizedBox(height: 4),
            Text(
              'Qty ${line.quantity}',
              style: type.bodyMedium.copyWith(color: colors.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
