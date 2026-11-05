import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/graphql_client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/mock_graphql_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'toJson and hydrate round-trip carts, items, deliveries, payments, and ids',
    () {
      final store = MockGraphqlStore();
      store.createCart();
      store.createCartItem(cartId: '1', catalogItemId: '13', quantity: 2);
      store.createDelivery(
        cartId: '1',
        street: '12 Loop Street',
        city: 'Cape Town',
        postalCode: '8001',
      );
      store.createPayment(cartId: '1', token: 'tok_visa');
      store.updatePayment(id: '1', token: 'tok_visa', fulfilled: true);

      final restored = MockGraphqlStore()..hydrate(jsonEncode(store.toJson()));

      expect(restored.carts['1']?['id'], '1');
      expect(restored.cartItems['1']?['quantity'], 2);
      expect(restored.deliveries['1']?['city'], 'Cape Town');
      expect(restored.payments['1']?['token'], 'tok_visa');
      expect(restored.payments['1']?['fulfilled'], isTrue);
      expect(jsonEncode(restored.toJson()), isNot(contains('catalogItems')));
      expect(jsonEncode(restored.toJson()), isNot(contains('deliveryTimes')));

      restored.createCart();
      restored.createCartItem(cartId: '2', catalogItemId: '1', quantity: 1);
      restored.createDelivery(
        cartId: '2',
        street: '1 Main',
        city: 'Durban',
        postalCode: '4001',
      );
      restored.createPayment(cartId: '2', token: 'tok_mc');
      expect(restored.carts.keys, containsAll(['1', '2']));
      expect(restored.cartItems.keys, containsAll(['1', '2']));
      expect(restored.deliveries.keys, containsAll(['1', '2']));
      expect(restored.payments.keys, containsAll(['1', '2']));
    },
  );

  test('hydrate ignores catalog seed keys and keeps hardcoded catalog', () {
    final store = MockGraphqlStore();
    final catalogCount = store.catalogItems.length;
    final timeCount = store.deliveryTimes.length;

    store.hydrate(
      jsonEncode({
        'nextCartId': 1,
        'catalogItems': <Map<String, dynamic>>[],
        'deliveryTimes': <Map<String, dynamic>>[],
      }),
    );

    expect(store.catalogItems.length, catalogCount);
    expect(store.deliveryTimes.length, timeCount);
  });

  test(
    'GraphqlClient hydrates from SharedPreferences after mutations',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final first = GraphqlClient(prefs);
      first.store.createCart();
      first.store.createCartItem(cartId: '1', catalogItemId: '1', quantity: 3);
      first.store.createDelivery(
        cartId: '1',
        street: '9 Bree',
        city: 'Cape Town',
        postalCode: '8000',
      );
      first.store.createPayment(cartId: '1', token: 'tok_persist');

      final second = GraphqlClient(prefs);
      expect(second.store.carts.containsKey('1'), isTrue);
      expect(second.store.cartItems['1']?['quantity'], 3);
      expect(second.store.deliveries['1']?['street'], '9 Bree');
      expect(second.store.payments['1']?['token'], 'tok_persist');
      expect(second.store.payments['1']?['fulfilled'], isFalse);
      expect(second.store.catalogItems, isNotEmpty);

      second.store.createCart();
      expect(second.store.carts.containsKey('2'), isTrue);
    },
  );
}
