import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/cart.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/interfaces/repositories/i_cart_repository.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/clients/cart_graph_client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_cart.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_cart.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_carts.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/update_cart.graphql.dart';
import 'package:refreshi_test/infrastructure/mappers/cart/cart_mapper.dart';
import 'package:refreshi_test/infrastructure/mappers/map_cart_error.dart';
import 'package:refreshi_test/infrastructure/shared/map_graph_model.dart';

@LazySingleton(as: ICartRepository)
class CartRepository implements ICartRepository {
  CartRepository(this._client, this._mapper);

  final CartGraphClient _client;
  final CartGraphModelToEntityMapper _mapper;

  @override
  TaskEither<BaseFailure, CartEntity> createCart(CartEntity entity) {
    return _client
        .createCart()
        .flatMap(
          (model) =>
              GraphModelMapper.mapCreate<
                Mutation$CreateCart$createCart,
                CartEntity
              >(
                model,
                mapper: _mapper,
                parseErrorType: GraphQlErrorType.cartParseError,
              ),
        )
        .mapLeft((error) => error.toCartFailure());
  }

  @override
  TaskEither<BaseFailure, CartEntity> getCart(int id) {
    return _client
        .getCart(id)
        .flatMap(
          (model) => GraphModelMapper.mapGet<Query$GetCart$getCart, CartEntity>(
            model,
            mapper: _mapper,
            parseErrorType: GraphQlErrorType.cartParseError,
          ),
        )
        .mapLeft((error) => error.toCartFailure());
  }

  @override
  TaskEither<BaseFailure, List<CartEntity>> getCarts() {
    return _client
        .getCarts()
        .flatMap(
          (items) => TaskEither.traverseList(
            items,
            (model) =>
                GraphModelMapper.mapListItem<
                  Query$GetCarts$getCarts,
                  CartEntity
                >(
                  model,
                  mapper: _mapper,
                  parseErrorType: GraphQlErrorType.cartParseError,
                ),
          ),
        )
        .mapLeft((error) => error.toCartFailure());
  }

  @override
  TaskEither<BaseFailure, CartEntity> updateCart(CartEntity entity) {
    return _client
        .updateCart(entity)
        .flatMap(
          (model) =>
              GraphModelMapper.mapUpdate<
                Mutation$UpdateCart$updateCart,
                CartEntity
              >(
                model,
                mapper: _mapper,
                parseErrorType: GraphQlErrorType.cartParseError,
              ),
        )
        .mapLeft((error) => error.toCartFailure());
  }

  @override
  TaskEither<BaseFailure, Unit> deleteCart(int id) {
    return _client.deleteCart(id).mapLeft((error) => error.toCartFailure());
  }
}
