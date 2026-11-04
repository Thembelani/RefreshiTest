import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refreshi_test/get_it.dart';
import 'package:refreshi_test/main.dart';
import 'package:refreshi_test/presentation/screens/catalog_screen/catalog_item.dart';
import 'package:refreshi_test/presentation/screens/catalog_screen/widgets/catalog_tile.dart';
import 'package:refreshi_test/presentation/state/bloc/auth/auth_bloc.dart';

void main() {
  setUp(() async {
    if (!getIt.isRegistered<AuthBloc>()) {
      await configureDependencies();
    }
  });

  testWidgets('catalog search filters tiles and taps update the cart count', (
    tester,
  ) async {
    await tester.pumpWidget(const RefreshiApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Log in'));
    await tester.pumpAndSettle();

    expect(catalogItems, hasLength(100));
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);

    final logoBox = tester.getRect(find.byKey(const Key('catalog-logo')));
    final searchBox = tester.getRect(find.byType(TextField));
    final cartBox = tester.getRect(find.byIcon(Icons.shopping_cart_outlined));
    expect(find.byKey(const Key('catalog-logo')), findsOneWidget);
    expect(logoBox.right, lessThan(searchBox.left));
    expect(searchBox.width, greaterThan(320));
    expect(cartBox.left, greaterThan(searchBox.right));
    final firstName = catalogItems.first.name;
    final lastName = catalogItems.last.name;

    expect(find.text(firstName), findsOneWidget);
    expect(find.text(catalogItems.first.priceLabel), findsWidgets);
    expect(find.text('Total: R0.00'), findsOneWidget);
    expect(find.text('Add to cart'), findsNothing);
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
    await tester.pump();
    await tester.tap(addFirst);
    await tester.pump();

    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('2')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: firstTile, matching: find.text('2')),
      findsOneWidget,
    );
    expect(
      find.text('Total: ${formatRand(catalogItems.first.priceCents * 2)}'),
      findsOneWidget,
    );

    await tester.tap(
      find.descendant(of: firstTile, matching: find.byIcon(Icons.remove)),
    );
    await tester.pump();

    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('1')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: firstTile, matching: find.text('1')),
      findsOneWidget,
    );
    expect(
      find.text('Total: ${formatRand(catalogItems.first.priceCents)}'),
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

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Address'), findsOneWidget);
    expect(find.text('Complete'), findsOneWidget);
  });
}
