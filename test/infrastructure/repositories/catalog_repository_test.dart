import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:refreshi_test/domain/failures/catalog_item_failures.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_catalog_items.graphql.dart';
import 'package:refreshi_test/infrastructure/mappers/catalog_item/catalog_item_mapper.dart';
import 'package:refreshi_test/infrastructure/repositories/catalog_repository.dart';

import '../../mocks.dart';

void main() {
  late MockCatalogItemGraphClient client;
  late CatalogRepository repository;

  setUp(() {
    client = MockCatalogItemGraphClient();
    repository = CatalogRepository(
      client,
      CatalogItemGraphModelToEntityMapper(),
    );
  });

  test('maps GraphQL models to catalog item entities', () async {
    when(() => client.getCatalogItems()).thenReturn(
      TaskEither.right([
        Query$GetCatalogItems$getCatalogItems(
          id: '1',
          name: 'Berry Latte',
          sellingPrice: 45.5,
          createdAt: '2026-01-01T00:00:00.000Z',
          updatedAt: '2026-01-01T00:00:00.000Z',
        ),
      ]),
    );

    final result = await repository.getCatalogItems().run();

    expect(result.isRight(), isTrue);
    result.match((_) => fail('expected entities'), (items) {
      expect(items, hasLength(1));
      expect(items.first.id, 1);
      expect(items.first.name, 'Berry Latte');
      expect(items.first.sellingPrice, 45.5);
    });
  });

  test('maps client errors to GetCatalogItemFailure', () async {
    when(() => client.getCatalogItems()).thenReturn(
      TaskEither.left(
        BaseGraphError(type: GraphQlErrorType.getCatalogItemError),
      ),
    );

    final result = await repository.getCatalogItems().run();

    expect(result.isLeft(), isTrue);
    result.match(
      (failure) => expect(failure, isA<GetCatalogItemFailure>()),
      (_) => fail('expected failure'),
    );
  });

  test('maps invalid ids to GetCatalogItemParseFailure', () async {
    when(() => client.getCatalogItems()).thenReturn(
      TaskEither.right([
        Query$GetCatalogItems$getCatalogItems(
          id: 'abc',
          name: 'Broken Item',
          sellingPrice: 1,
          createdAt: '2026-01-01T00:00:00.000Z',
          updatedAt: '2026-01-01T00:00:00.000Z',
        ),
      ]),
    );

    final result = await repository.getCatalogItems().run();

    expect(result.isLeft(), isTrue);
    result.match(
      (failure) => expect(failure, isA<GetCatalogItemParseFailure>()),
      (_) => fail('expected failure'),
    );
  });
}
