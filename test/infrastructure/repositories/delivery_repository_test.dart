import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:refreshi_test/domain/entities/delivery.dart';
import 'package:refreshi_test/domain/failures/delivery_failures.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_delivery.graphql.dart';
import 'package:refreshi_test/infrastructure/mappers/delivery/delivery_mapper.dart';
import 'package:refreshi_test/infrastructure/repositories/delivery_repository.dart';

import '../../mocks.dart';

void main() {
  late MockDeliveryGraphClient client;
  late DeliveryRepository repository;
  final now = DateTime.utc(2026, 1, 1);
  final placeholder = DeliveryEntity(
    id: 0,
    cartId: 1,
    street: '12 Long Street',
    city: 'Cape Town',
    postalCode: '8001',
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    client = MockDeliveryGraphClient();
    repository = DeliveryRepository(
      client,
      DeliveryGraphModelToEntityMapper(),
    );
  });

  test('maps created GraphQL delivery to entity', () async {
    when(() => client.createDelivery(placeholder)).thenReturn(
      TaskEither.right(
        Mutation$CreateDelivery$createDelivery(
          id: '4',
          cartId: '1',
          street: '12 Long Street',
          city: 'Cape Town',
          postalCode: '8001',
          createdAt: '2026-01-01T00:00:00.000Z',
          updatedAt: '2026-01-01T00:00:00.000Z',
        ),
      ),
    );

    final result = await repository.createDelivery(placeholder).run();

    expect(result.isRight(), isTrue);
    result.match((_) => fail('expected delivery'), (delivery) {
      expect(delivery.id, 4);
      expect(delivery.cartId, 1);
      expect(delivery.street, '12 Long Street');
      expect(delivery.deliveryTimeId, isNull);
    });
  });

  test('maps client errors to DeliveryFailure', () async {
    when(() => client.createDelivery(placeholder)).thenReturn(
      TaskEither.left(BaseGraphError(type: GraphQlErrorType.deliveryError)),
    );

    final result = await repository.createDelivery(placeholder).run();

    expect(result.isLeft(), isTrue);
    result.match(
      (failure) => expect(failure, isA<DeliveryFailure>()),
      (_) => fail('expected failure'),
    );
  });
}
