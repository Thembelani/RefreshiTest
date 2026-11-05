import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/domain/entities/catalog_item.dart';
import 'package:refreshi_test/presentation/shared/format_rand.dart';

extension CartItemEntityX on CartItemEntity {
  bool get isActive => deletedAt == null && quantity > 0;

  CatalogItemEntity? catalogItem(List<CatalogItemEntity> catalogItems) {
    for (final candidate in catalogItems) {
      if (candidate.id == catalogItemId) {
        return candidate;
      }
    }
    return null;
  }

  int priceCents(CatalogItemEntity catalog) =>
      sellingPriceToCents(catalog.sellingPrice);

  String summary(CatalogItemEntity catalog) => formatRand(priceCents(catalog));
}

extension CartItemEntitiesX on Iterable<CartItemEntity> {
  Iterable<CartItemEntity> get active => where((item) => item.isActive);

  int totalCents(List<CatalogItemEntity> catalogItems) {
    var total = 0;
    for (final item in active) {
      final catalog = item.catalogItem(catalogItems);
      if (catalog == null) {
        continue;
      }
      total += item.priceCents(catalog) * item.quantity;
    }
    return total;
  }
}
