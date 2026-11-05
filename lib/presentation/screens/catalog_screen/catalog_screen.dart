import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshi_test/bootstrap/router/app_router.gr.dart';
import 'package:refreshi_test/bootstrap/theme/theme_extensions/util_extensions.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/domain/entities/catalog_item.dart';
import 'package:refreshi_test/presentation/screens/catalog_screen/widgets/catalog_tile.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/cart_panel.dart';
import 'package:refreshi_test/shared/format_rand.dart';
import 'package:refreshi_test/presentation/state/bloc/cart/cart_bloc.dart';
import 'package:refreshi_test/presentation/state/bloc/catalog_items/catalog_items_bloc.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';

@RoutePage()
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    final catalogBloc = context.read<CatalogItemsBloc>();
    if (catalogBloc.state.status == DataStatus.none) {
      catalogBloc.add(const CatalogItemsEvent.getCatalogItems());
    }
    context.read<CartBloc>().add(const CartEvent.startCart());
  }

  List<CatalogItemEntity> _visibleItems(List<CatalogItemEntity> items) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) {
      return items;
    }

    return items
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;

    return BlocListener<CartBloc, CartState>(
      listenWhen: (previous, current) =>
          !previous.checkoutPrepared && current.checkoutPrepared,
      listener: (context, state) {
        context.router.push(const CheckoutRoute());
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          toolbarHeight: 72,
          titleSpacing: 24,
          title: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    key: const Key('catalog-logo'),
                    height: 32,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: constraints.maxWidth * 0.6,
                        child: TextField(
                          style: type.bodyLarge.copyWith(
                            color: colors.onBackground,
                          ),
                          cursorColor: colors.primary,
                          decoration: InputDecoration(
                            hintText: 'Search services',
                            hintStyle: type.bodyMedium.copyWith(
                              color: colors.onSurface,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: colors.onSurface,
                            ),
                            filled: true,
                            fillColor: colors.surface,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) => setState(() => _query = value),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  return Badge(
                    isLabelVisible: cartState.itemCount > 0,
                    backgroundColor: colors.primary,
                    textColor: colors.onPrimary,
                    label: Text('${cartState.itemCount}'),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: colors.onBackground,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: BlocBuilder<CatalogItemsBloc, CatalogItemsState>(
          builder: (context, catalogState) {
            return BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                final items = _visibleItems(catalogState.items);
                return items.isEmpty
                    ? Center(
                        child: Text(
                          'No services match your search.',
                          style: type.bodyLarge.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(24),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.62,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return CatalogTile(
                            item: item,
                            quantity: cartState.quantityFor(item.id),
                            onAdd: () => context.read<CartBloc>().add(
                                  CartEvent.addCatalogItem(
                                    catalogItemId: item.id,
                                  ),
                                ),
                            onRemove: () => context.read<CartBloc>().add(
                                  CartEvent.decrementCatalogItem(
                                    catalogItemId: item.id,
                                  ),
                                ),
                          );
                        },
                      );
              },
            );
          },
        ),
        bottomNavigationBar: Material(
          color: colors.surface,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: BlocBuilder<CatalogItemsBloc, CatalogItemsState>(
                      builder: (context, catalogState) {
                        return BlocBuilder<CartBloc, CartState>(
                          builder: (context, cartState) {
                            return Text(
                              'Total: ${formatRand(_totalCents(cartState.items, catalogState.items))}',
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style: type.titleMedium.copyWith(
                                color: colors.onBackground,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, cartState) {
                      final canCheckout = cartState.activeItems.isNotEmpty &&
                          cartState.status != DataStatus.loading;
                      return FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          disabledBackgroundColor:
                              colors.onSurface.withValues(alpha: 0.2),
                          minimumSize: const Size(230, 52),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          textStyle: type.labelLarge,
                        ),
                        onPressed: canCheckout
                            ? () => context.read<CartBloc>().add(
                                  const CartEvent.prepareCheckout(),
                                )
                            : null,
                        child: const Text('Checkout'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _totalCents(
    List<CartItemEntity> cartItems,
    List<CatalogItemEntity> catalogItems,
  ) {
    return cartTotalCents(
      cartLinesFrom(items: cartItems, catalogItems: catalogItems),
    );
  }
}
