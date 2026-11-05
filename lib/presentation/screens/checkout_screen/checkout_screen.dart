import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshi_test/bootstrap/router/app_router.gr.dart';
import 'package:refreshi_test/bootstrap/theme/theme_extensions/util_extensions.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/domain/entities/catalog_item.dart';
import 'package:refreshi_test/domain/entities/delivery.dart';
import 'package:refreshi_test/domain/entities/delivery_time.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/cart_panel.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/checkout_pane.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/delivery_time_card.dart';
import 'package:refreshi_test/presentation/shared/view_model_extensions/cart_item_extension.dart';
import 'package:refreshi_test/presentation/state/bloc/cart/cart_bloc.dart';
import 'package:refreshi_test/presentation/state/bloc/catalog_items/catalog_items_bloc.dart';
import 'package:refreshi_test/presentation/state/bloc/delivery_times/delivery_times_bloc.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';

part 'address_lines.dart';
part 'card_details.dart';
part 'checkout_body.dart';

const _paneGap = 12.0;
const _screenInset = 24.0;
const _stackBreakpoint = 900.0;

List<String> _addressLines(DeliveryEntity? delivery) {
  final street = delivery?.street ?? '12 Long Street';
  final city = delivery?.city ?? 'Cape Town';
  final postalCode = delivery?.postalCode ?? '8001';
  return [street, '$city, $postalCode'];
}

@RoutePage()
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    final timesBloc = context.read<DeliveryTimesBloc>();
    if (timesBloc.state.status == DataStatus.none) {
      timesBloc.add(const DeliveryTimesEvent.getDeliveryTimes());
    }
    context.read<CartBloc>().add(const CartEvent.ensureCheckoutDetails());
  }

  @override
  Widget build(BuildContext context) {
    final stacked = MediaQuery.sizeOf(context).width < _stackBreakpoint;

    return BlocListener<CartBloc, CartState>(
      listenWhen: (previous, current) =>
          !previous.isPlaced && current.isPlaced,
      listener: (context, state) {
        context.router.push(const OrderSummaryRoute());
      },
      child: BlocListener<CartBloc, CartState>(
        listenWhen: (previous, current) =>
            current.cart != null &&
            (current.delivery == null || current.payment == null) &&
            current.status != DataStatus.loading,
        listener: (context, state) {
          context.read<CartBloc>().add(const CartEvent.ensureCheckoutDetails());
        },
        child: BlocBuilder<CatalogItemsBloc, CatalogItemsState>(
          builder: (context, catalogState) {
            return BlocBuilder<DeliveryTimesBloc, DeliveryTimesState>(
              builder: (context, timesState) {
                return BlocBuilder<CartBloc, CartState>(
                  builder: (context, cartState) {
                    return _CheckoutBody(
                      stacked: stacked,
                      items: cartState.items,
                      catalogItems: catalogState.items,
                      addressLines: _addressLines(cartState.delivery),
                      deliveryTimes: timesState.items,
                      selectedDeliveryTimeId:
                          cartState.delivery?.deliveryTimeId,
                      canComplete: cartState.items.active.isNotEmpty &&
                          cartState.delivery?.deliveryTimeId != null &&
                          !cartState.isPlaced &&
                          cartState.status != DataStatus.loading,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
