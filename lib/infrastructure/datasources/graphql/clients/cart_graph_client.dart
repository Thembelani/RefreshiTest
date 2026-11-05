import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/cart.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/graphql_client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_cart.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/delete_cart.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_cart.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_carts.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/update_cart.graphql.dart';

@lazySingleton
class CartGraphClient {
  CartGraphClient(this._graphql);

  final GraphqlClient _graphql;

  TaskEither<BaseGraphError, Mutation$CreateCart$createCart> createCart() {
    return TaskEither.tryCatch(
      () => _graphql.client.mutate$CreateCart(),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.cartError,
      ),
    ).map((res) => res.parsedData!.createCart);
  }

  TaskEither<BaseGraphError, Query$GetCart$getCart> getCart(int id) {
    return TaskEither.tryCatch(
      () => _graphql.client.query$GetCart(
        Options$Query$GetCart(
          variables: Variables$Query$GetCart(id: '$id'),
        ),
      ),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.cartError,
      ),
    ).map((res) {
      final cart = res.parsedData?.getCart;
      if (cart == null) {
        throw StateError('Cart $id not found');
      }
      return cart;
    });
  }

  TaskEither<BaseGraphError, List<Query$GetCarts$getCarts>> getCarts() {
    return TaskEither.tryCatch(
      () => _graphql.client.query$GetCarts(),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.cartError,
      ),
    ).map((res) => res.parsedData!.getCarts);
  }

  TaskEither<BaseGraphError, Mutation$UpdateCart$updateCart> updateCart(
    CartEntity entity,
  ) {
    return TaskEither.tryCatch(
      () => _graphql.client.mutate$UpdateCart(
        Options$Mutation$UpdateCart(
          variables: Variables$Mutation$UpdateCart(
            id: '${entity.id}',
            placedAt: entity.placedAt?.toUtc().toIso8601String(),
          ),
        ),
      ),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.cartError,
      ),
    ).map((res) => res.parsedData!.updateCart);
  }

  TaskEither<BaseGraphError, Unit> deleteCart(int id) {
    return TaskEither.tryCatch(
      () => _graphql.client.mutate$DeleteCart(
        Options$Mutation$DeleteCart(
          variables: Variables$Mutation$DeleteCart(id: '$id'),
        ),
      ),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.cartError,
      ),
    ).map((res) {
      if (res.parsedData?.deleteCart != true) {
        throw StateError('Cart $id was not deleted');
      }
      return unit;
    });
  }
}
