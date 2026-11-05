

import 'package:fpdart/fpdart.dart';
import 'package:refreshi_test/domain/entities/catalog_item.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';

abstract class ICatalogRepository {
  TaskEither<BaseFailure, List<CatalogItemEntity>> getCatalogItems();
}