import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/i_usecase.dart';
import 'package:refreshi_test/application/use_cases/no_params.dart';
import 'package:refreshi_test/domain/entities/catalog_item.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/interfaces/repositories/i_catalog_repository.dart';

@LazySingleton()
class GetCatalogItemsUseCase
    implements UseCase<List<CatalogItemEntity>, NoParams> {
  GetCatalogItemsUseCase(this.repository);

  final ICatalogRepository repository;

  @override
  TaskEither<BaseFailure, List<CatalogItemEntity>> call(NoParams params) {
    return repository.getCatalogItems();
  }
}
