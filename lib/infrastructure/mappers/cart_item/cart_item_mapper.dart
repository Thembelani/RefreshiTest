import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_cart_item.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_cart_item.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_cart_items.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/update_cart_item.graphql.dart';

import 'cart_item_mapper.auto_mappr.dart';

@lazySingleton
@AutoMappr([
  MapType<Mutation$CreateCartItem$createCartItem, CartItemEntity>(
    fields: [
      Field.custom(
        'id',
        custom: CartItemGraphModelToEntityMapper.parseCreateId,
      ),
      Field.custom(
        'cartId',
        custom: CartItemGraphModelToEntityMapper.parseCreateCartId,
      ),
      Field.custom(
        'catalogItemId',
        custom: CartItemGraphModelToEntityMapper.parseCreateCatalogItemId,
      ),
      Field.custom(
        'createdAt',
        custom: CartItemGraphModelToEntityMapper.parseCreateCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: CartItemGraphModelToEntityMapper.parseCreateUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: CartItemGraphModelToEntityMapper.parseCreateDeletedAt,
      ),
    ],
  ),
  MapType<Query$GetCartItem$getCartItem, CartItemEntity>(
    fields: [
      Field.custom('id', custom: CartItemGraphModelToEntityMapper.parseGetId),
      Field.custom(
        'cartId',
        custom: CartItemGraphModelToEntityMapper.parseGetCartId,
      ),
      Field.custom(
        'catalogItemId',
        custom: CartItemGraphModelToEntityMapper.parseGetCatalogItemId,
      ),
      Field.custom(
        'createdAt',
        custom: CartItemGraphModelToEntityMapper.parseGetCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: CartItemGraphModelToEntityMapper.parseGetUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: CartItemGraphModelToEntityMapper.parseGetDeletedAt,
      ),
    ],
  ),
  MapType<Query$GetCartItems$getCartItems, CartItemEntity>(
    fields: [
      Field.custom('id', custom: CartItemGraphModelToEntityMapper.parseListId),
      Field.custom(
        'cartId',
        custom: CartItemGraphModelToEntityMapper.parseListCartId,
      ),
      Field.custom(
        'catalogItemId',
        custom: CartItemGraphModelToEntityMapper.parseListCatalogItemId,
      ),
      Field.custom(
        'createdAt',
        custom: CartItemGraphModelToEntityMapper.parseListCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: CartItemGraphModelToEntityMapper.parseListUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: CartItemGraphModelToEntityMapper.parseListDeletedAt,
      ),
    ],
  ),
  MapType<Mutation$UpdateCartItem$updateCartItem, CartItemEntity>(
    fields: [
      Field.custom(
        'id',
        custom: CartItemGraphModelToEntityMapper.parseUpdateId,
      ),
      Field.custom(
        'cartId',
        custom: CartItemGraphModelToEntityMapper.parseUpdateCartId,
      ),
      Field.custom(
        'catalogItemId',
        custom: CartItemGraphModelToEntityMapper.parseUpdateCatalogItemId,
      ),
      Field.custom(
        'createdAt',
        custom: CartItemGraphModelToEntityMapper.parseUpdateCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: CartItemGraphModelToEntityMapper.parseUpdateUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: CartItemGraphModelToEntityMapper.parseUpdateDeletedAt,
      ),
    ],
  ),
])
class CartItemGraphModelToEntityMapper
    extends $CartItemGraphModelToEntityMapper {
  static int parseCreateId(Mutation$CreateCartItem$createCartItem model) =>
      int.parse(model.id);
  static int parseCreateCartId(Mutation$CreateCartItem$createCartItem model) =>
      int.parse(model.cartId);
  static int parseCreateCatalogItemId(
    Mutation$CreateCartItem$createCartItem model,
  ) => int.parse(model.catalogItemId);
  static DateTime parseCreateCreatedAt(
    Mutation$CreateCartItem$createCartItem model,
  ) => DateTime.parse(model.createdAt);
  static DateTime parseCreateUpdatedAt(
    Mutation$CreateCartItem$createCartItem model,
  ) => DateTime.parse(model.updatedAt);
  static DateTime? parseCreateDeletedAt(
    Mutation$CreateCartItem$createCartItem model,
  ) => _parseDeletedAt(model.deletedAt);

  static int parseGetId(Query$GetCartItem$getCartItem model) =>
      int.parse(model.id);
  static int parseGetCartId(Query$GetCartItem$getCartItem model) =>
      int.parse(model.cartId);
  static int parseGetCatalogItemId(Query$GetCartItem$getCartItem model) =>
      int.parse(model.catalogItemId);
  static DateTime parseGetCreatedAt(Query$GetCartItem$getCartItem model) =>
      DateTime.parse(model.createdAt);
  static DateTime parseGetUpdatedAt(Query$GetCartItem$getCartItem model) =>
      DateTime.parse(model.updatedAt);
  static DateTime? parseGetDeletedAt(Query$GetCartItem$getCartItem model) =>
      _parseDeletedAt(model.deletedAt);

  static int parseListId(Query$GetCartItems$getCartItems model) =>
      int.parse(model.id);
  static int parseListCartId(Query$GetCartItems$getCartItems model) =>
      int.parse(model.cartId);
  static int parseListCatalogItemId(Query$GetCartItems$getCartItems model) =>
      int.parse(model.catalogItemId);
  static DateTime parseListCreatedAt(Query$GetCartItems$getCartItems model) =>
      DateTime.parse(model.createdAt);
  static DateTime parseListUpdatedAt(Query$GetCartItems$getCartItems model) =>
      DateTime.parse(model.updatedAt);
  static DateTime? parseListDeletedAt(Query$GetCartItems$getCartItems model) =>
      _parseDeletedAt(model.deletedAt);

  static int parseUpdateId(Mutation$UpdateCartItem$updateCartItem model) =>
      int.parse(model.id);
  static int parseUpdateCartId(Mutation$UpdateCartItem$updateCartItem model) =>
      int.parse(model.cartId);
  static int parseUpdateCatalogItemId(
    Mutation$UpdateCartItem$updateCartItem model,
  ) => int.parse(model.catalogItemId);
  static DateTime parseUpdateCreatedAt(
    Mutation$UpdateCartItem$updateCartItem model,
  ) => DateTime.parse(model.createdAt);
  static DateTime parseUpdateUpdatedAt(
    Mutation$UpdateCartItem$updateCartItem model,
  ) => DateTime.parse(model.updatedAt);
  static DateTime? parseUpdateDeletedAt(
    Mutation$UpdateCartItem$updateCartItem model,
  ) => _parseDeletedAt(model.deletedAt);

  static DateTime? _parseDeletedAt(String? value) =>
      value == null ? null : DateTime.parse(value);
}
