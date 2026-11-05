import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/cart.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_cart.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_cart.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_carts.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/update_cart.graphql.dart';

import 'cart_mapper.auto_mappr.dart';

@lazySingleton
@AutoMappr([
  MapType<Mutation$CreateCart$createCart, CartEntity>(
    fields: [
      Field.custom('id', custom: CartGraphModelToEntityMapper.parseCreateId),
      Field.custom(
        'createdAt',
        custom: CartGraphModelToEntityMapper.parseCreateCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: CartGraphModelToEntityMapper.parseCreateUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: CartGraphModelToEntityMapper.parseCreateDeletedAt,
      ),
    ],
  ),
  MapType<Query$GetCart$getCart, CartEntity>(
    fields: [
      Field.custom('id', custom: CartGraphModelToEntityMapper.parseGetId),
      Field.custom(
        'createdAt',
        custom: CartGraphModelToEntityMapper.parseGetCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: CartGraphModelToEntityMapper.parseGetUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: CartGraphModelToEntityMapper.parseGetDeletedAt,
      ),
    ],
  ),
  MapType<Query$GetCarts$getCarts, CartEntity>(
    fields: [
      Field.custom('id', custom: CartGraphModelToEntityMapper.parseListId),
      Field.custom(
        'createdAt',
        custom: CartGraphModelToEntityMapper.parseListCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: CartGraphModelToEntityMapper.parseListUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: CartGraphModelToEntityMapper.parseListDeletedAt,
      ),
    ],
  ),
  MapType<Mutation$UpdateCart$updateCart, CartEntity>(
    fields: [
      Field.custom('id', custom: CartGraphModelToEntityMapper.parseUpdateId),
      Field.custom(
        'createdAt',
        custom: CartGraphModelToEntityMapper.parseUpdateCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: CartGraphModelToEntityMapper.parseUpdateUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: CartGraphModelToEntityMapper.parseUpdateDeletedAt,
      ),
    ],
  ),
])
class CartGraphModelToEntityMapper extends $CartGraphModelToEntityMapper {
  static int parseCreateId(Mutation$CreateCart$createCart model) =>
      int.parse(model.id);
  static DateTime parseCreateCreatedAt(Mutation$CreateCart$createCart model) =>
      DateTime.parse(model.createdAt);
  static DateTime parseCreateUpdatedAt(Mutation$CreateCart$createCart model) =>
      DateTime.parse(model.updatedAt);
  static DateTime? parseCreateDeletedAt(Mutation$CreateCart$createCart model) =>
      _parseDeletedAt(model.deletedAt);

  static int parseGetId(Query$GetCart$getCart model) => int.parse(model.id);
  static DateTime parseGetCreatedAt(Query$GetCart$getCart model) =>
      DateTime.parse(model.createdAt);
  static DateTime parseGetUpdatedAt(Query$GetCart$getCart model) =>
      DateTime.parse(model.updatedAt);
  static DateTime? parseGetDeletedAt(Query$GetCart$getCart model) =>
      _parseDeletedAt(model.deletedAt);

  static int parseListId(Query$GetCarts$getCarts model) => int.parse(model.id);
  static DateTime parseListCreatedAt(Query$GetCarts$getCarts model) =>
      DateTime.parse(model.createdAt);
  static DateTime parseListUpdatedAt(Query$GetCarts$getCarts model) =>
      DateTime.parse(model.updatedAt);
  static DateTime? parseListDeletedAt(Query$GetCarts$getCarts model) =>
      _parseDeletedAt(model.deletedAt);

  static int parseUpdateId(Mutation$UpdateCart$updateCart model) =>
      int.parse(model.id);
  static DateTime parseUpdateCreatedAt(Mutation$UpdateCart$updateCart model) =>
      DateTime.parse(model.createdAt);
  static DateTime parseUpdateUpdatedAt(Mutation$UpdateCart$updateCart model) =>
      DateTime.parse(model.updatedAt);
  static DateTime? parseUpdateDeletedAt(Mutation$UpdateCart$updateCart model) =>
      _parseDeletedAt(model.deletedAt);

  static DateTime? _parseDeletedAt(String? value) =>
      value == null ? null : DateTime.parse(value);
}
