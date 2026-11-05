import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refreshi_test/bootstrap/providers/global_provider.dart';
import 'package:refreshi_test/bootstrap/router/app_router.dart';
import 'package:refreshi_test/bootstrap/router/app_router.gr.dart';
import 'package:refreshi_test/bootstrap/theme/app_theme.dart';
import 'package:refreshi_test/get_it.dart';
import 'package:refreshi_test/presentation/screens/catalog_screen/catalog_item.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/cart_panel.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/checkout_pane.dart';
import 'package:refreshi_test/presentation/screens/order_summary_screen/order_summary_screen.dart';
import 'package:refreshi_test/presentation/state/bloc/cart/cart_bloc.dart';
import 'package:refreshi_test/presentation/state/bloc/catalog_items/catalog_items_bloc.dart';

import '../helpers/seed_cart.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    await configureDependencies();
  });

  testWidgets('order summary shows items, details, and total', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      GlobalProvider.create(
        materialApp: MaterialApp(
          theme: AppTheme.theme,
          home: const OrderSummaryScreen(),
        ),
      ),
    );
    await tester.pump();
    await seedCatalogAndCart(tester);

    final lines = cartLinesFrom(
      items: getIt<CartBloc>().state.items,
      catalogItems: getIt<CatalogItemsBloc>().state.items,
    );
    final totalCents = cartTotalCents(lines);

    expect(find.byKey(const Key('order-summary-logo')), findsOneWidget);
    expect(find.text('Order Summary'), findsOneWidget);
    expect(find.text('Items'), findsOneWidget);
    expect(find.text('Details'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);
    expect(find.text('12 Long Street, Cape Town, 8001'), findsOneWidget);
    expect(find.text('Card'), findsOneWidget);
    expect(find.text('Visa ending 4242'), findsOneWidget);
    expect(find.text(lines.first.service.name), findsOneWidget);
    expect(find.text('Total: ${formatRand(totalCents)}'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    final done = find.widgetWithText(FilledButton, 'Done');
    expect(tester.widget<FilledButton>(done).onPressed, isNotNull);
    final doneBox = tester.getRect(done);
    expect(doneBox.width, greaterThanOrEqualTo(230));
    expect(doneBox.height, greaterThanOrEqualTo(52));

    await tester.scrollUntilVisible(
      find.text(lines.last.service.name),
      200,
      scrollable: find.descendant(
        of: find.byType(CheckoutPane).last,
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text(lines.last.service.name), findsOneWidget);
  });

  testWidgets('complete on checkout opens order summary', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = AppRouter();
    await tester.pumpWidget(
      GlobalProvider.create(
        materialApp: MaterialApp.router(
          theme: AppTheme.theme,
          routerConfig: router.config(
            deepLinkBuilder: (_) => DeepLink.single(const CheckoutRoute()),
          ),
        ),
      ),
    );
    await tester.pump();
    await seedCatalogAndCart(tester);

    expect(find.text('Complete'), findsOneWidget);
    await tester.tap(find.text('Complete'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Order Summary'), findsOneWidget);
    expect(find.byType(OrderSummaryScreen), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Done'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsOneWidget);
  });
}
