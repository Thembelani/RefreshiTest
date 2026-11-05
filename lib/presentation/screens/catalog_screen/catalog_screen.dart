import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshi_test/bootstrap/router/app_router.gr.dart';
import 'package:refreshi_test/bootstrap/theme/theme_extensions/util_extensions.dart';
import 'package:refreshi_test/presentation/screens/catalog_screen/catalog_item.dart';
import 'package:refreshi_test/presentation/screens/catalog_screen/widgets/catalog_tile.dart';
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
  final Map<String, int> _quantities = {};

  @override
  void initState() {
    super.initState();
    final bloc = context.read<CatalogItemsBloc>();
    if (bloc.state.status == DataStatus.none) {
      bloc.add(const CatalogItemsEvent.getCatalogItems());
    }
  }

  int get _itemCount =>
      _quantities.values.fold(0, (total, quantity) => total + quantity);

  int get _totalCents => catalogItems.fold(0, (total, item) {
    final quantity = _quantities[item.id] ?? 0;
    return total + item.priceCents * quantity;
  });

  void _changeQuantity(CatalogItem item, int delta) {
    final next = (_quantities[item.id] ?? 0) + delta;
    if (next < 0) {
      return;
    }

    setState(() {
      if (next == 0) {
        _quantities.remove(item.id);
      } else {
        _quantities[item.id] = next;
      }
    });
  }

  List<CatalogItem> get _visibleItems {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) {
      return catalogItems;
    }

    return catalogItems
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;
    final items = _visibleItems;

    return Scaffold(
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
            child: Badge(
              isLabelVisible: _itemCount > 0,
              backgroundColor: colors.primary,
              textColor: colors.onPrimary,
              label: Text('$_itemCount'),
              child: Icon(
                Icons.shopping_cart_outlined,
                color: colors.onBackground,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CatalogItemsBloc, CatalogItemsState>(
        bloc: context.read<CatalogItemsBloc>(),
        builder: (context, state) {
          return state.items.isEmpty
              ? Center(
                  child: Text(
                    'No services match your search.',
                    style: type.bodyLarge.copyWith(color: colors.onSurface),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];

                    return Text("HI");
                    // return CatalogTile(
                    //   item: item,
                    //   quantity: _quantities[item.id] ?? 0,
                    //   onAdd: () => _changeQuantity(item, 1),
                    //   onRemove: () => _changeQuantity(item, -1),
                    // );
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
                  child: Text(
                    'Total: ${formatRand(_totalCents)}',
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: type.titleMedium.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    minimumSize: const Size(230, 52),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: type.labelLarge,
                  ),
                  onPressed: () => context.router.push(const CheckoutRoute()),
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
