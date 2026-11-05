import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:refreshi_test/domain/entities/cart.dart';
import 'package:refreshi_test/domain/failures/cart_failures.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_cart.graphql.dart';
import 'package:refreshi_test/infrastructure/mappers/cart/cart_mapper.dart';
import 'package:refreshi_test/infrastructure/repositories/cart_repository.dart';

import '../../mocks.dart';

void main() {
  late MockCartGraphClient client;
  late CartRepository repository;
  final now = DateTime.utc(2026, 1, 1);
  final placeholder = CartEntity(id: 0, createdAt: now, updatedAt: now);

  setUp(() {
    client = MockCartGraphClient();
    repository = CartRepository(client, CartGraphModelToEntityMapper());
  });

  test('maps created GraphQL cart to entity', () async {
    when(() => client.createCart()).thenReturn(
      TaskEither.right(
        Mutation$CreateCart$createCart(
          id: '4',
          createdAt: '2026-01-01T00:00:00.000Z',
          updatedAt: '2026-01-01T00:00:00.000Z',
        ),
      ),
    );

    final result = await repository.createCart(placeholder).run();

    expect(result.isRight(), isTrue);
    result.match((_) => fail('expected cart'), (cart) {
      expect(cart.id, 4);
      expect(cart.deletedAt, isNull);
    });
  });

  test('maps client errors to CartFailure', () async {
    when(() => client.createCart()).thenReturn(
      TaskEither.left(BaseGraphError(type: GraphQlErrorType.cartError)),
    );

    final result = await repository.createCart(placeholder).run();

    expect(result.isLeft(), isTrue);
    result.match(
      (failure) => expect(failure, isA<CartFailure>()),
      (_) => fail('expected failure'),
    );
  });

  test('maps invalid ids to CartParseFailure', () async {
    when(() => client.createCart()).thenReturn(
      TaskEither.right(
        Mutation$CreateCart$createCart(
          id: 'abc',
          createdAt: '2026-01-01T00:00:00.000Z',
          updatedAt: '2026-01-01T00:00:00.000Z',
        ),
      ),
    );

    final result = await repository.createCart(placeholder).run();

    expect(result.isLeft(), isTrue);
    result.match(
      (failure) => expect(failure, isA<CartParseFailure>()),
      (_) => fail('expected failure'),
    );
  });
}
