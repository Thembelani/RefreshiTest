import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:refreshi_test/application/use_cases/no_params.dart';
import 'package:refreshi_test/domain/entities/catalog_item.dart';
import 'package:refreshi_test/domain/failures/catalog_item_failures.dart';
import 'package:refreshi_test/presentation/state/bloc/catalog_items/catalog_items_bloc.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';

import '../../../../mocks.dart';

void main() {
  late MockGetCatalogItemsUseCase useCase;
  late CatalogItemsBloc bloc;

  final items = [
    CatalogItemEntity(
      id: 1,
      name: 'Berry Latte',
      sellingPrice: 45.5,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    ),
  ];

  setUp(() {
    useCase = MockGetCatalogItemsUseCase();
    bloc = CatalogItemsBloc(useCase);
  });

  tearDown(() async {
    await bloc.close();
  });

  test('starts with no items and none status', () {
    expect(bloc.state, const CatalogItemsState());
  });

  test('getCatalogItems emits loading then success with items', () async {
    when(
      () => useCase.call(const NoParams()),
    ).thenReturn(TaskEither.right(items));

    bloc.add(const CatalogItemsEvent.getCatalogItems());
    await pumpEventQueue();

    expect(
      bloc.state,
      CatalogItemsState(status: DataStatus.success, items: items),
    );
  });

  test('getCatalogItems emits loading then error on failure', () async {
    final failure = GetCatalogItemFailure();
    when(
      () => useCase.call(const NoParams()),
    ).thenReturn(TaskEither.left(failure));

    bloc.add(const CatalogItemsEvent.getCatalogItems());
    await pumpEventQueue();

    expect(
      bloc.state,
      CatalogItemsState(status: DataStatus.error, failure: failure),
    );
  });
}
