import 'package:flutter_test/flutter_test.dart';
import 'package:refreshi_test/get_it.dart';
import 'package:refreshi_test/presentation/state/bloc/cart/cart_bloc.dart';
import 'package:refreshi_test/presentation/state/bloc/catalog_items/catalog_items_bloc.dart';

Future<void> seedCatalogAndCart(
  WidgetTester tester, {
  int itemCount = 13,
}) async {
  getIt<CatalogItemsBloc>().add(const CatalogItemsEvent.getCatalogItems());
  getIt<CartBloc>().add(const CartEvent.startCart());
  await tester.pump();
  await tester.pumpAndSettle();

  final items = getIt<CatalogItemsBloc>().state.items.take(itemCount).toList();
  for (var i = 0; i < items.length; i++) {
    final quantity = (i % 3) + 1;
    for (var n = 0; n < quantity; n++) {
      getIt<CartBloc>().add(
        CartEvent.addCatalogItem(catalogItemId: items[i].id),
      );
      await tester.pump();
    }
  }
  getIt<CartBloc>().add(const CartEvent.ensureCheckoutDetails());
  await tester.pumpAndSettle();
}
