import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/i_usecase.dart';
import 'package:refreshi_test/application/use_cases/no_params.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/interfaces/repositories/i_cart_item_repository.dart';

@LazySingleton()
class GetCartItemsUseCase implements UseCase<List<CartItemEntity>, NoParams> {
  GetCartItemsUseCase(this.repository);

  final ICartItemRepository repository;

  @override
  TaskEither<BaseFailure, List<CartItemEntity>> call(NoParams params) {
    return repository.getCartItems();
  }
}
