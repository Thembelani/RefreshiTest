import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/graphql_client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_cart_item.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/delete_cart_item.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_cart_item.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_cart_items.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/update_cart_item.graphql.dart';

@lazySingleton
class CartItemGraphClient {
  CartItemGraphClient(this._graphql);

  final GraphqlClient _graphql;

  TaskEither<BaseGraphError, Mutation$CreateCartItem$createCartItem>
  createCartItem(CartItemEntity entity) {
    return TaskEither.tryCatch(
      () => _graphql.client.mutate$CreateCartItem(
        Options$Mutation$CreateCartItem(
          variables: Variables$Mutation$CreateCartItem(
            cartId: '${entity.cartId}',
            catalogItemId: '${entity.catalogItemId}',
            quantity: entity.quantity,
          ),
        ),
      ),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.cartItemError,
      ),
    ).map((res) => res.parsedData!.createCartItem);
  }

  TaskEither<BaseGraphError, Query$GetCartItem$getCartItem> getCartItem(
    int id,
  ) {
    return TaskEither.tryCatch(
      () => _graphql.client.query$GetCartItem(
        Options$Query$GetCartItem(
          variables: Variables$Query$GetCartItem(id: '$id'),
        ),
      ),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.cartItemError,
      ),
    ).map((res) {
      final item = res.parsedData?.getCartItem;
      if (item == null) {
        throw StateError('Cart item $id not found');
      }
      return item;
    });
  }

  TaskEither<BaseGraphError, List<Query$GetCartItems$getCartItems>>
  getCartItems() {
    return TaskEither.tryCatch(
      () => _graphql.client.query$GetCartItems(),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.cartItemError,
      ),
    ).map((res) => res.parsedData!.getCartItems);
  }

  TaskEither<BaseGraphError, Mutation$UpdateCartItem$updateCartItem>
  updateCartItem(CartItemEntity entity) {
    return TaskEither.tryCatch(
      () => _graphql.client.mutate$UpdateCartItem(
        Options$Mutation$UpdateCartItem(
          variables: Variables$Mutation$UpdateCartItem(
            id: '${entity.id}',
            quantity: entity.quantity,
            deletedAt: entity.deletedAt?.toUtc().toIso8601String(),
          ),
        ),
      ),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.cartItemError,
      ),
    ).map((res) => res.parsedData!.updateCartItem);
  }

  TaskEither<BaseGraphError, Unit> deleteCartItem(int id) {
    return TaskEither.tryCatch(
      () => _graphql.client.mutate$DeleteCartItem(
        Options$Mutation$DeleteCartItem(
          variables: Variables$Mutation$DeleteCartItem(id: '$id'),
        ),
      ),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.cartItemError,
      ),
    ).map((res) {
      if (res.parsedData?.deleteCartItem != true) {
        throw StateError('Cart item $id was not deleted');
      }
      return unit;
    });
  }
}
