import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/i_usecase.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/interfaces/repositories/i_cart_item_repository.dart';

@LazySingleton()
class UpdateCartItemUseCase implements UseCase<CartItemEntity, CartItemEntity> {
  UpdateCartItemUseCase(this.repository);

  final ICartItemRepository repository;

  @override
  TaskEither<BaseFailure, CartItemEntity> call(CartItemEntity params) {
    return repository.updateCartItem(params);
  }
}
