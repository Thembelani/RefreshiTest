import 'package:fpdart/fpdart.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';

abstract class ICartItemRepository {
  TaskEither<BaseFailure, CartItemEntity> createCartItem(CartItemEntity entity);
  TaskEither<BaseFailure, CartItemEntity> getCartItem(int id);
  TaskEither<BaseFailure, List<CartItemEntity>> getCartItems();
  TaskEither<BaseFailure, CartItemEntity> updateCartItem(CartItemEntity entity);
  TaskEither<BaseFailure, Unit> deleteCartItem(int id);
}
