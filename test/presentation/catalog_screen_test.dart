import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refreshi_test/get_it.dart';
import 'package:refreshi_test/main.dart';
import 'package:refreshi_test/presentation/shared/format_rand.dart';
import 'package:refreshi_test/presentation/screens/catalog_screen/widgets/catalog_tile.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    await configureDependencies();
  });

  testWidgets('catalog search filters tiles and taps update the cart count', (
    tester,
  ) async {
    await tester.pumpWidget(const RefreshiApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('login-email')), 'a@b.com');
    await tester.enterText(
      find.byKey(const Key('login-password')),
      'Test1234',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Log in'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);

    final logoBox = tester.getRect(find.byKey(const Key('catalog-logo')));
    final searchBox = tester.getRect(find.byType(TextField));
    final cartBox = tester.getRect(find.byIcon(Icons.shopping_cart_outlined));
    expect(find.byKey(const Key('catalog-logo')), findsOneWidget);
    expect(logoBox.right, lessThan(searchBox.left));
    expect(searchBox.width, greaterThan(320));
    expect(cartBox.left, greaterThan(searchBox.right));
    const firstName = 'Berry Latte';
    const lastName = 'Copper Draught';
    const firstPriceCents = 4550;

    expect(find.text(firstName), findsOneWidget);
    expect(find.text(formatRand(firstPriceCents)), findsWidgets);
    expect(find.text('Total: R0.00'), findsOneWidget);
    expect(find.text('Add to cart'), findsNothing);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Checkout'))
          .onPressed,
      isNull,
    );
    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('1')),
      findsNothing,
    );

    final firstTile = find.widgetWithText(CatalogTile, firstName);
    expect(
      find.descendant(of: firstTile, matching: find.text('0')),
      findsOneWidget,
    );

    final addFirst = find.descendant(
      of: firstTile,
      matching: find.byIcon(Icons.add),
    );
    await tester.tap(addFirst);
    await tester.pumpAndSettle();
    await tester.tap(addFirst);
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('2')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: firstTile, matching: find.text('2')),
      findsOneWidget,
    );
    expect(
      find.text('Total: ${formatRand(firstPriceCents * 2)}'),
      findsOneWidget,
    );

    await tester.tap(
      find.descendant(of: firstTile, matching: find.byIcon(Icons.remove)),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('1')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: firstTile, matching: find.text('1')),
      findsOneWidget,
    );
    expect(
      find.text('Total: ${formatRand(firstPriceCents)}'),
      findsOneWidget,
    );

    final tileBox = tester.getRect(firstTile);
    final removeBox = tester.getRect(
      find.descendant(of: firstTile, matching: find.byIcon(Icons.remove)),
    );
    expect(removeBox.left, greaterThan(tileBox.left + tileBox.width * 0.45));

    await tester.enterText(find.byType(TextField), lastName);
    await tester.pump();

    expect(
      find.descendant(
        of: find.byType(CatalogTile),
        matching: find.text(lastName),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(CatalogTile),
        matching: find.text(firstName),
      ),
      findsNothing,
    );

    final total = tester.widget<Text>(find.textContaining('Total:'));
    expect(total.textAlign, TextAlign.right);

    final checkoutBox = tester.getRect(
      find.widgetWithText(FilledButton, 'Checkout'),
    );
    expect(checkoutBox.width, greaterThanOrEqualTo(230));
    expect(checkoutBox.height, greaterThanOrEqualTo(52));
    expect(checkoutBox.right, greaterThan(searchBox.right));

    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Checkout'))
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Address'), findsOneWidget);
    expect(find.text('Complete'), findsOneWidget);
  });
}
