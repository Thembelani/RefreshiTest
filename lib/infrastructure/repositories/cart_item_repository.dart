import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/interfaces/repositories/i_cart_item_repository.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/clients/cart_item_graph_client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_cart_item.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_cart_item.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_cart_items.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/update_cart_item.graphql.dart';
import 'package:refreshi_test/infrastructure/mappers/cart_item/cart_item_mapper.dart';
import 'package:refreshi_test/infrastructure/mappers/map_cart_error.dart';
import 'package:refreshi_test/infrastructure/shared/map_graph_model.dart';

@LazySingleton(as: ICartItemRepository)
class CartItemRepository implements ICartItemRepository {
  CartItemRepository(this._client, this._mapper);

  final CartItemGraphClient _client;
  final CartItemGraphModelToEntityMapper _mapper;

  @override
  TaskEither<BaseFailure, CartItemEntity> createCartItem(
    CartItemEntity entity,
  ) {
    return _client
        .createCartItem(entity)
        .flatMap(
          (model) =>
              GraphModelMapper.mapCreate<
                Mutation$CreateCartItem$createCartItem,
                CartItemEntity
              >(
                model,
                mapper: _mapper,
                parseErrorType: GraphQlErrorType.cartItemParseError,
              ),
        )
        .mapLeft((error) => error.toCartFailure());
  }

  @override
  TaskEither<BaseFailure, CartItemEntity> getCartItem(int id) {
    return _client
        .getCartItem(id)
        .flatMap(
          (model) =>
              GraphModelMapper.mapGet<
                Query$GetCartItem$getCartItem,
                CartItemEntity
              >(
                model,
                mapper: _mapper,
                parseErrorType: GraphQlErrorType.cartItemParseError,
              ),
        )
        .mapLeft((error) => error.toCartFailure());
  }

  @override
  TaskEither<BaseFailure, List<CartItemEntity>> getCartItems() {
    return _client
        .getCartItems()
        .flatMap(
          (items) => TaskEither.traverseList(
            items,
            (model) =>
                GraphModelMapper.mapListItem<
                  Query$GetCartItems$getCartItems,
                  CartItemEntity
                >(
                  model,
                  mapper: _mapper,
                  parseErrorType: GraphQlErrorType.cartItemParseError,
                ),
          ),
        )
        .mapLeft((error) => error.toCartFailure());
  }

  @override
  TaskEither<BaseFailure, CartItemEntity> updateCartItem(
    CartItemEntity entity,
  ) {
    return _client
        .updateCartItem(entity)
        .flatMap(
          (model) =>
              GraphModelMapper.mapUpdate<
                Mutation$UpdateCartItem$updateCartItem,
                CartItemEntity
              >(
                model,
                mapper: _mapper,
                parseErrorType: GraphQlErrorType.cartItemParseError,
              ),
        )
        .mapLeft((error) => error.toCartFailure());
  }

  @override
  TaskEither<BaseFailure, Unit> deleteCartItem(int id) {
    return _client.deleteCartItem(id).mapLeft((error) => error.toCartFailure());
  }
}
