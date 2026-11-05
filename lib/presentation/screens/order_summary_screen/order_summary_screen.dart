import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshi_test/bootstrap/router/app_router.gr.dart';
import 'package:refreshi_test/bootstrap/theme/app_palette/app_colors_extension.dart';
import 'package:refreshi_test/bootstrap/theme/theme_extensions/util_extensions.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/cart_panel.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/checkout_pane.dart';
import 'package:refreshi_test/presentation/shared/view_model_extensions/cart_item_extension.dart';
import 'package:refreshi_test/presentation/shared/format_rand.dart';
import 'package:refreshi_test/presentation/state/bloc/auth/auth_bloc.dart';
import 'package:refreshi_test/presentation/state/bloc/catalog_items/catalog_items_bloc.dart';
import 'package:refreshi_test/presentation/state/bloc/order_summary/order_summary_bloc.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';
import 'package:refreshi_test/presentation/widgets/spacing/padding_constants.dart';
import 'package:refreshi_test/presentation/widgets/spacing/radius_constants.dart';
import 'package:refreshi_test/presentation/widgets/spacing/spacer_constants.dart';

part 'hold_loading_overlay.dart';
part 'hold_status.dart';
part 'hold_timeline.dart';
part 'order_details.dart';
part 'order_id.dart';

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String _formatOrderDate(DateTime date) {
  final local = date.toLocal();
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '${local.day} ${_months[local.month - 1]} ${local.year}, $hour:$minute';
}

@RoutePage()
class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({@PathParam('id') required this.id, super.key});

  final int id;

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  @override
  void initState() {
    super.initState();
    final catalogBloc = context.read<CatalogItemsBloc>();
    if (catalogBloc.state.status == DataStatus.none) {
      catalogBloc.add(const CatalogItemsEvent.getCatalogItems());
    }
    context.read<OrderSummaryBloc>().add(
      OrderSummaryEvent.load(cartId: widget.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final type = context.theme.appTypography;
    final orderState = context.watch<OrderSummaryBloc>().state;
    final catalogState = context.watch<CatalogItemsBloc>().state;
    final cart = orderState.cart;
    final payment = orderState.payment;
    final delivery = orderState.delivery;
    final address = delivery == null
        ? '12 Long Street, Cape Town, 8001'
        : '${delivery.street}, ${delivery.city}, ${delivery.postalCode}';
    final items = orderState.items.active.toList();
    final catalogItems = catalogState.items;
    final totalCents = items.totalCents(catalogItems);
    final waitingForHold = orderState.isPlaced && !orderState.isFulfilled;

    return BlocListener<OrderSummaryBloc, OrderSummaryState>(
      listenWhen: (previous, current) =>
          previous.status != DataStatus.success &&
          current.status == DataStatus.success &&
          current.isPlaced &&
          current.payment != null &&
          !current.isFulfilled,
      listener: (context, state) {
        context.read<OrderSummaryBloc>().add(
          const OrderSummaryEvent.fulfillPayment(),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Scaffold(
            appBar: AppBar(
              centerTitle: false,
              toolbarHeight: 72,
              titleSpacing: 24,
              title: Image.asset(
                'assets/images/logo.png',
                key: const Key('order-summary-logo'),
                height: 32,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Order Summary',
                    style: type.headlineSmall.copyWith(
                      color: colors.onBackground,
                    ),
                  ),
                  if (cart != null) ...[
                    hSpacer16,
                    Row(
                      children: [
                        _OrderId(id: cart.id),
                        const Spacer(),
                        _HoldStatus(fulfilled: payment?.fulfilled == true),
                      ],
                    ),
                    hSpacer16,
                    _HoldTimeline(
                      createdAt: cart.placedAt ?? cart.createdAt,
                      fulfilled: payment?.fulfilled == true,
                      fulfilledAt: payment?.fulfilled == true
                          ? payment?.updatedAt
                          : null,
                    ),
                  ],
                  hSpacer16,
                  _OrderDetails(address: address),
                  hSpacer12,
                  Expanded(
                    child: CheckoutPane(
                      title: 'Items',
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: items.length,
                        separatorBuilder: (context, index) => hSpacer12,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final catalog = item.catalogItem(catalogItems);
                          if (catalog == null) {
                            return const SizedBox.shrink();
                          }
                          return CartItemCard(item: item, catalog: catalog);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Material(
              color: colors.background,
              child: SafeArea(
                child: Padding(
                  padding: allPadding24,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total: ${formatRand(totalCents)}',
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: type.titleMedium.copyWith(
                            color: colors.onBackground,
                          ),
                        ),
                      ),
                      wSpacer16,
                      BlocConsumer<AuthBloc, AuthState>(
                        listenWhen: (prev, current) =>
                            prev.status != current.status &&
                            current.status == DataStatus.success,
                        listener: (context, state) {
                          context.router.push(const LoginRoute());
                        },
                        builder: (context, state) {
                          return FilledButton(
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
                            onPressed: waitingForHold
                                ? null
                                : () {
                                    context.read<AuthBloc>().add(
                                      AuthEvent.signOut(),
                                    );
                                  },
                            child: const Text('Done'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (waitingForHold)
            const Positioned.fill(child: _HoldLoadingOverlay()),
        ],
      ),
    );
  }
}
