import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refreshi_test/bootstrap/providers/global_provider.dart';
import 'package:refreshi_test/bootstrap/theme/app_theme.dart';
import 'package:refreshi_test/get_it.dart';
import 'package:refreshi_test/presentation/shared/format_rand.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/checkout_screen.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/cart_panel.dart';
import 'package:refreshi_test/presentation/shared/view_model_extensions/cart_item_extension.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/checkout_pane.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/delivery_time_card.dart';
import 'package:refreshi_test/presentation/screens/checkout_screen/widgets/service_card.dart';
import 'package:refreshi_test/presentation/state/bloc/cart/cart_bloc.dart';
import 'package:refreshi_test/presentation/state/bloc/catalog_items/catalog_items_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/seed_cart.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await getIt.reset();
    await configureDependencies();
  });

  testWidgets('checkout cart shows cart items, scrolls, and can complete', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      GlobalProvider.create(
        materialApp: MaterialApp(
          theme: AppTheme.theme,
          home: const CheckoutScreen(),
        ),
      ),
    );
    await tester.pump();
    await seedCatalogAndCart(tester);

    final cartItems = getIt<CartBloc>().state.items.active.toList();
    final catalogItems = getIt<CatalogItemsBloc>().state.items;
    final firstCatalog = cartItems.first.catalogItem(catalogItems)!;
    final lastCatalog = cartItems.last.catalogItem(catalogItems)!;
    expect(cartItems, isNotEmpty);
    expect(find.byKey(const Key('checkout-logo')), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);
    expect(find.text('Card Details'), findsOneWidget);
    expect(find.text('Select Delivery Times'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.byType(CheckoutPane), findsNWidgets(4));
    final leftTop = tester.getRect(find.byKey(const Key('checkout-left-top')));
    final leftBottom = tester.getRect(
      find.byKey(const Key('checkout-left-bottom')),
    );
    expect(leftTop.height, closeTo(leftBottom.height * 2, 8));
    expect(leftBottom.top - leftTop.bottom, closeTo(12, 8));
    final leftTopStart = tester.getRect(
      find.byKey(const Key('checkout-left-top-start')),
    );
    final leftTopEnd = tester.getRect(
      find.byKey(const Key('checkout-left-top-end')),
    );
    expect(leftTopStart.width, closeTo(leftTopEnd.width, 8));
    expect(leftTopEnd.left - leftTopStart.right, closeTo(12, 8));
    expect(find.text('12 Long Street'), findsOneWidget);
    expect(find.text('Cape Town, 8001'), findsOneWidget);
    expect(find.text('Card'), findsOneWidget);
    expect(find.text('Visa ending 4242'), findsOneWidget);
    expect(find.text('Expires'), findsOneWidget);
    expect(find.text('12/28'), findsOneWidget);
    expect(find.text('CVV'), findsOneWidget);
    expect(find.byKey(const Key('card-cvv-field')), findsOneWidget);
    final cardTitle = tester.getRect(find.text('Card'));
    final expiresTitle = tester.getRect(find.text('Expires'));
    final cvvTitle = tester.getRect(find.text('CVV'));
    expect(cardTitle.left, closeTo(expiresTitle.left, 1));
    expect(expiresTitle.left, closeTo(cvvTitle.left, 1));
    final cardValue = tester.getRect(find.text('Visa ending 4242'));
    final expiresValue = tester.getRect(find.text('12/28'));
    final cvvValue = tester.getRect(find.byKey(const Key('card-cvv-field')));
    expect(cardValue.left, closeTo(expiresValue.left, 1));
    expect(expiresValue.left, closeTo(cvvValue.left, 1));
    expect(cardTitle.right, lessThan(cardValue.left));
    expect(cvvValue.width, closeTo(72, 1));

    await tester.enterText(find.byKey(const Key('card-cvv-field')), '1234');
    await tester.pump();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      '123',
    );
    expect(find.byType(DeliveryTimeCard), findsWidgets);
    expect(find.text('1 Dec'), findsWidgets);
    expect(find.text('9:00 am'), findsWidgets);
    expect(find.byIcon(Icons.check_circle), findsNothing);

    final firstTimeCard = find.byType(DeliveryTimeCard).first;
    await tester.tap(firstTimeCard);
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: firstTimeCard,
        matching: find.byIcon(Icons.check_circle),
      ),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(
      find.text('5 Dec'),
      200,
      scrollable: find.descendant(
        of: find.byKey(const Key('delivery-time-scroller')),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text('5 Dec'), findsWidgets);
    expect(find.text('Brew'), findsNothing);
    expect(find.byType(ServiceCard), findsNothing);
    expect(find.text('Cart is empty'), findsNothing);
    expect(find.text('Complete'), findsOneWidget);
    final complete = find.widgetWithText(FilledButton, 'Complete');
    expect(tester.widget<FilledButton>(complete).onPressed, isNotNull);
    final completeBox = tester.getRect(complete);
    expect(completeBox.width, greaterThanOrEqualTo(230));
    expect(completeBox.height, greaterThanOrEqualTo(52));

    final cart = find.byType(CartPanel);
    expect(
      find.descendant(of: cart, matching: find.text('Complete')),
      findsNothing,
    );
    final cartBox = tester.getRect(cart);
    expect(completeBox.top, greaterThan(cartBox.bottom - 1));
    expect(completeBox.left, greaterThanOrEqualTo(cartBox.left - 1));
    expect(completeBox.right, closeTo(cartBox.right, 8));
    expect(
      find.descendant(of: cart, matching: find.text(firstCatalog.name)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: cart, matching: find.byType(CartItemCard)),
      findsWidgets,
    );
    final firstCard = find
        .descendant(of: cart, matching: find.byType(CartItemCard))
        .first;
    expect(
      find.descendant(
        of: firstCard,
        matching: find.text(cartItems.first.summary(firstCatalog)),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: firstCard,
        matching: find.text('Qty ${cartItems.first.quantity}'),
      ),
      findsOneWidget,
    );
    final removeFirst = find.byKey(Key('cart-remove-${firstCatalog.id}'));
    final firstCardBox = tester.getRect(firstCard);
    final titleBox = tester.getRect(
      find.descendant(of: firstCard, matching: find.text(firstCatalog.name)),
    );
    final removeBox = tester.getRect(removeFirst);
    expect(removeBox.right, closeTo(firstCardBox.right, 16));
    expect(removeBox.center.dy, closeTo(titleBox.center.dy, 2));
    final removeIcon = tester.widget<Icon>(
      find.descendant(of: removeFirst, matching: find.byType(Icon)),
    );
    expect(removeIcon.icon, Icons.delete_outline);
    expect(removeIcon.color, AppTheme.appColors.primary);
    final totals = find.descendant(
      of: cart,
      matching: find.byKey(const Key('cart-totals')),
    );
    expect(totals, findsOneWidget);
    expect(
      find.descendant(of: totals, matching: find.text('Total')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: totals,
        matching: find.text(formatRand(cartItems.totalCents(catalogItems))),
      ),
      findsOneWidget,
    );
    final totalsBox = tester.getRect(totals);
    expect(totalsBox.bottom, closeTo(cartBox.bottom - 16, 8));
    expect(totalsBox.top, greaterThan(cartBox.top));

    await tester.tap(removeFirst);
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: cart, matching: find.text(firstCatalog.name)),
      findsNothing,
    );
    expect(
      find.descendant(
        of: totals,
        matching: find.text(
          formatRand(cartItems.skip(1).totalCents(catalogItems)),
        ),
      ),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(
      find.descendant(of: cart, matching: find.text(lastCatalog.name)),
      200,
      scrollable: find.descendant(of: cart, matching: find.byType(Scrollable)),
    );

    expect(
      find.descendant(of: cart, matching: find.text(lastCatalog.name)),
      findsOneWidget,
    );
    expect(tester.getRect(totals).top, closeTo(totalsBox.top, 1));
  });

  testWidgets('checkout stacks panes on a narrow window', (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      GlobalProvider.create(
        materialApp: MaterialApp(
          theme: AppTheme.theme,
          home: const CheckoutScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('checkout-left-top')), findsNothing);

    final address = tester.getRect(
      find.byKey(const Key('checkout-left-top-start')),
    );
    final card = tester.getRect(find.byKey(const Key('checkout-left-top-end')));
    final times = tester.getRect(find.byKey(const Key('checkout-left-bottom')));
    final cart = tester.getRect(find.byType(CartPanel));

    expect(address.bottom, lessThan(card.top));
    expect(card.bottom, lessThan(times.top));
    expect(times.bottom, lessThan(cart.top));
    expect(find.text('Complete'), findsOneWidget);
  });
}
