import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/domain/failures/cart_failures.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_cart_item.graphql.dart';
import 'package:refreshi_test/infrastructure/mappers/cart_item/cart_item_mapper.dart';
import 'package:refreshi_test/infrastructure/repositories/cart_item_repository.dart';

import '../../mocks.dart';

void main() {
  late MockCartItemGraphClient client;
  late CartItemRepository repository;
  final now = DateTime.utc(2026, 1, 1);
  final placeholder = CartItemEntity(
    id: 0,
    cartId: 1,
    catalogItemId: 3,
    quantity: 1,
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    client = MockCartItemGraphClient();
    repository = CartItemRepository(
      client,
      CartItemGraphModelToEntityMapper(),
    );
  });

  test('maps created GraphQL cart item to entity', () async {
    when(() => client.createCartItem(placeholder)).thenReturn(
      TaskEither.right(
        Mutation$CreateCartItem$createCartItem(
          id: '8',
          cartId: '1',
          catalogItemId: '3',
          quantity: 1,
          createdAt: '2026-01-01T00:00:00.000Z',
          updatedAt: '2026-01-01T00:00:00.000Z',
        ),
      ),
    );

    final result = await repository.createCartItem(placeholder).run();

    expect(result.isRight(), isTrue);
    result.match((_) => fail('expected cart item'), (item) {
      expect(item.id, 8);
      expect(item.cartId, 1);
      expect(item.catalogItemId, 3);
      expect(item.quantity, 1);
    });
  });

  test('maps client errors to CartItemFailure', () async {
    when(() => client.createCartItem(placeholder)).thenReturn(
      TaskEither.left(BaseGraphError(type: GraphQlErrorType.cartItemError)),
    );

    final result = await repository.createCartItem(placeholder).run();

    expect(result.isLeft(), isTrue);
    result.match(
      (failure) => expect(failure, isA<CartItemFailure>()),
      (_) => fail('expected failure'),
    );
  });
}
