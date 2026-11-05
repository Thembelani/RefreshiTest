import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/i_usecase.dart';
import 'package:refreshi_test/domain/entities/cart.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/interfaces/repositories/i_cart_repository.dart';

@LazySingleton()
class GetCartUseCase implements UseCase<CartEntity, int> {
  GetCartUseCase(this.repository);

  final ICartRepository repository;

  @override
  TaskEither<BaseFailure, CartEntity> call(int params) {
    return repository.getCart(params);
  }
}
