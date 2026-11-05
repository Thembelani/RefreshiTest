import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refreshi_test/bootstrap/providers/global_provider.dart';
import 'package:refreshi_test/bootstrap/theme/app_theme.dart';
import 'package:refreshi_test/get_it.dart';
import 'package:refreshi_test/presentation/shared/format_rand.dart';
import 'package:refreshi_test/presentation/shared/view_model_extensions/cart_item_extension.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/checkout_pane.dart';
import 'package:refreshi_test/presentation/screens/order_summary_screen/order_summary_screen.dart';
import 'package:refreshi_test/presentation/state/bloc/cart/cart_bloc.dart';
import 'package:refreshi_test/presentation/state/bloc/catalog_items/catalog_items_bloc.dart';
import 'package:refreshi_test/presentation/state/bloc/delivery_times/delivery_times_bloc.dart';
import 'package:refreshi_test/presentation/state/bloc/order_summary/order_summary_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/seed_cart.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await getIt.reset();
    await configureDependencies();
  });

  Future<void> pumpHost(WidgetTester tester) {
    return tester.pumpWidget(
      GlobalProvider.create(
        materialApp: MaterialApp(theme: AppTheme.theme, home: const SizedBox()),
      ),
    );
  }

  Future<void> pumpOrderSummary(WidgetTester tester, int cartId) {
    return tester.pumpWidget(
      GlobalProvider.create(
        materialApp: MaterialApp(
          theme: AppTheme.theme,
          home: OrderSummaryScreen(id: cartId),
        ),
      ),
    );
  }

  Future<int> seedUnplacedCart(WidgetTester tester) async {
    await seedCatalogAndCart(tester);
    return getIt<CartBloc>().state.cart!.id;
  }

  Future<int> placeSeededCart(WidgetTester tester) async {
    final cartId = await seedUnplacedCart(tester);
    getIt<DeliveryTimesBloc>().add(const DeliveryTimesEvent.getDeliveryTimes());
    await tester.pumpAndSettle();
    final timeId = getIt<DeliveryTimesBloc>().state.items.first.id;
    getIt<CartBloc>().add(CartEvent.selectDeliveryTime(deliveryTimeId: timeId));
    await tester.pumpAndSettle();
    getIt<CartBloc>().add(const CartEvent.placeOrder());
    await tester.pump();
    return cartId;
  }

  testWidgets('order summary loads cart by id, not leftover CartBloc state', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpHost(tester);
    await tester.pump();
    final cartId = await seedUnplacedCart(tester);
    final cartItems = getIt<CartBloc>().state.items.active.toList();
    final catalogItems = getIt<CatalogItemsBloc>().state.items;
    final firstCatalog = cartItems.first.catalogItem(catalogItems)!;
    final lastCatalog = cartItems.last.catalogItem(catalogItems)!;
    final totalCents = cartItems.totalCents(catalogItems);

    getIt<CartBloc>().add(const CartEvent.startCart());
    await tester.pumpAndSettle();
    expect(getIt<CartBloc>().state.cart?.id, isNot(cartId));
    expect(getIt<CartBloc>().state.items, isEmpty);

    await pumpOrderSummary(tester, cartId);
    await tester.pump();

    expect(getIt<OrderSummaryBloc>().state.cart?.id, cartId);
    expect(find.byKey(const Key('order-summary-logo')), findsOneWidget);
    expect(find.text('Order Summary'), findsOneWidget);
    expect(find.text('Order #$cartId'), findsOneWidget);
    expect(find.byKey(const Key('order-id')), findsOneWidget);
    expect(find.byKey(const Key('hold-status')), findsOneWidget);
    expect(find.text('Pending'), findsWidgets);
    expect(find.byKey(const Key('hold-timeline')), findsOneWidget);
    expect(find.text('Created'), findsOneWidget);
    expect(find.text('Fulfilled'), findsOneWidget);
    expect(find.text('Items'), findsOneWidget);
    expect(find.text('Details'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);
    expect(find.text('12 Long Street, Cape Town, 8001'), findsOneWidget);
    expect(find.text('Card'), findsOneWidget);
    expect(find.text('Visa ending 4242'), findsOneWidget);
    expect(find.text(firstCatalog.name), findsOneWidget);
    expect(find.text('Total: ${formatRand(totalCents)}'), findsOneWidget);
    expect(find.byKey(const Key('hold-loading-overlay')), findsNothing);
    expect(find.text('Done'), findsOneWidget);
    final done = find.widgetWithText(FilledButton, 'Done');
    expect(tester.widget<FilledButton>(done).onPressed, isNotNull);
    final doneBox = tester.getRect(done);
    expect(doneBox.width, greaterThanOrEqualTo(230));
    expect(doneBox.height, greaterThanOrEqualTo(52));

    await tester.scrollUntilVisible(
      find.text(lastCatalog.name),
      200,
      scrollable: find.descendant(
        of: find.byType(CheckoutPane).last,
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text(lastCatalog.name), findsOneWidget);
  });

  testWidgets('order summary shows a loading overlay until the hold fulfills', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpHost(tester);
    await tester.pump();
    final cartId = await placeSeededCart(tester);

    await pumpOrderSummary(tester, cartId);
    await tester.pump();
    await tester.pump();

    expect(getIt<OrderSummaryBloc>().state.isPlaced, isTrue);
    expect(getIt<OrderSummaryBloc>().state.payment?.fulfilled, isFalse);
    expect(find.byKey(const Key('hold-loading-overlay')), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Pending'), findsWidgets);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Done'))
          .onPressed,
      isNull,
    );

    await tester.pump(const Duration(seconds: 10));
    await tester.pump();

    expect(getIt<OrderSummaryBloc>().state.payment?.fulfilled, isTrue);
    expect(find.byKey(const Key('hold-loading-overlay')), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Pending'), findsNothing);
    expect(find.text('Fulfilled'), findsWidgets);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Done'))
          .onPressed,
      isNotNull,
    );
  });
}
