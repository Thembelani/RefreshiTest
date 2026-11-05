import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:refreshi_test/domain/failures/delivery_time_failures.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_delivery_times.graphql.dart';
import 'package:refreshi_test/infrastructure/mappers/delivery_time/delivery_time_mapper.dart';
import 'package:refreshi_test/infrastructure/repositories/delivery_time_repository.dart';

import '../../mocks.dart';

void main() {
  late MockDeliveryTimeGraphClient client;
  late DeliveryTimeRepository repository;

  setUp(() {
    client = MockDeliveryTimeGraphClient();
    repository = DeliveryTimeRepository(
      client,
      DeliveryTimeGraphModelToEntityMapper(),
    );
  });

  test('maps GraphQL models to delivery time entities', () async {
    when(() => client.getDeliveryTimes()).thenReturn(
      TaskEither.right([
        Query$GetDeliveryTimes$getDeliveryTimes(
          id: '1',
          day: '1 Dec',
          time: '9:00 am',
          createdAt: '2026-01-01T00:00:00.000Z',
          updatedAt: '2026-01-01T00:00:00.000Z',
        ),
      ]),
    );

    final result = await repository.getDeliveryTimes().run();

    expect(result.isRight(), isTrue);
    result.match((_) => fail('expected entities'), (items) {
      expect(items, hasLength(1));
      expect(items.first.id, 1);
      expect(items.first.day, '1 Dec');
      expect(items.first.time, '9:00 am');
    });
  });

  test('maps client errors to GetDeliveryTimeFailure', () async {
    when(() => client.getDeliveryTimes()).thenReturn(
      TaskEither.left(
        BaseGraphError(type: GraphQlErrorType.deliveryTimeError),
      ),
    );

    final result = await repository.getDeliveryTimes().run();

    expect(result.isLeft(), isTrue);
    result.match(
      (failure) => expect(failure, isA<GetDeliveryTimeFailure>()),
      (_) => fail('expected failure'),
    );
  });
}
