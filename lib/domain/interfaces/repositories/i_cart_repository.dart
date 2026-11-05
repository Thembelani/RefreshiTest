import 'package:fpdart/fpdart.dart';
import 'package:refreshi_test/domain/entities/cart.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';

abstract class ICartRepository {
  TaskEither<BaseFailure, CartEntity> createCart(CartEntity entity);
  TaskEither<BaseFailure, CartEntity> getCart(int id);
  TaskEither<BaseFailure, List<CartEntity>> getCarts();
  TaskEither<BaseFailure, CartEntity> updateCart(CartEntity entity);
  TaskEither<BaseFailure, Unit> deleteCart(int id);
}
