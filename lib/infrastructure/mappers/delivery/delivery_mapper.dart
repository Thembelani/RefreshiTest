import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/delivery.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_delivery.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_deliveries.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_delivery.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/update_delivery.graphql.dart';

import 'delivery_mapper.auto_mappr.dart';

@lazySingleton
@AutoMappr([
  MapType<Mutation$CreateDelivery$createDelivery, DeliveryEntity>(
    fields: [
      Field.custom(
        'id',
        custom: DeliveryGraphModelToEntityMapper.parseCreateId,
      ),
      Field.custom(
        'cartId',
        custom: DeliveryGraphModelToEntityMapper.parseCreateCartId,
      ),
      Field.custom(
        'deliveryTimeId',
        custom: DeliveryGraphModelToEntityMapper.parseCreateDeliveryTimeId,
      ),
      Field.custom(
        'createdAt',
        custom: DeliveryGraphModelToEntityMapper.parseCreateCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: DeliveryGraphModelToEntityMapper.parseCreateUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: DeliveryGraphModelToEntityMapper.parseCreateDeletedAt,
      ),
    ],
  ),
  MapType<Query$GetDelivery$getDelivery, DeliveryEntity>(
    fields: [
      Field.custom('id', custom: DeliveryGraphModelToEntityMapper.parseGetId),
      Field.custom(
        'cartId',
        custom: DeliveryGraphModelToEntityMapper.parseGetCartId,
      ),
      Field.custom(
        'deliveryTimeId',
        custom: DeliveryGraphModelToEntityMapper.parseGetDeliveryTimeId,
      ),
      Field.custom(
        'createdAt',
        custom: DeliveryGraphModelToEntityMapper.parseGetCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: DeliveryGraphModelToEntityMapper.parseGetUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: DeliveryGraphModelToEntityMapper.parseGetDeletedAt,
      ),
    ],
  ),
  MapType<Query$GetDeliveries$getDeliveries, DeliveryEntity>(
    fields: [
      Field.custom('id', custom: DeliveryGraphModelToEntityMapper.parseListId),
      Field.custom(
        'cartId',
        custom: DeliveryGraphModelToEntityMapper.parseListCartId,
      ),
      Field.custom(
        'deliveryTimeId',
        custom: DeliveryGraphModelToEntityMapper.parseListDeliveryTimeId,
      ),
      Field.custom(
        'createdAt',
        custom: DeliveryGraphModelToEntityMapper.parseListCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: DeliveryGraphModelToEntityMapper.parseListUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: DeliveryGraphModelToEntityMapper.parseListDeletedAt,
      ),
    ],
  ),
  MapType<Mutation$UpdateDelivery$updateDelivery, DeliveryEntity>(
    fields: [
      Field.custom(
        'id',
        custom: DeliveryGraphModelToEntityMapper.parseUpdateId,
      ),
      Field.custom(
        'cartId',
        custom: DeliveryGraphModelToEntityMapper.parseUpdateCartId,
      ),
      Field.custom(
        'deliveryTimeId',
        custom: DeliveryGraphModelToEntityMapper.parseUpdateDeliveryTimeId,
      ),
      Field.custom(
        'createdAt',
        custom: DeliveryGraphModelToEntityMapper.parseUpdateCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: DeliveryGraphModelToEntityMapper.parseUpdateUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: DeliveryGraphModelToEntityMapper.parseUpdateDeletedAt,
      ),
    ],
  ),
])
class DeliveryGraphModelToEntityMapper
    extends $DeliveryGraphModelToEntityMapper {
  static int parseCreateId(Mutation$CreateDelivery$createDelivery model) =>
      int.parse(model.id);
  static int parseCreateCartId(
    Mutation$CreateDelivery$createDelivery model,
  ) => int.parse(model.cartId);
  static int? parseCreateDeliveryTimeId(
    Mutation$CreateDelivery$createDelivery model,
  ) => _parseOptionalId(model.deliveryTimeId);
  static DateTime parseCreateCreatedAt(
    Mutation$CreateDelivery$createDelivery model,
  ) => DateTime.parse(model.createdAt);
  static DateTime parseCreateUpdatedAt(
    Mutation$CreateDelivery$createDelivery model,
  ) => DateTime.parse(model.updatedAt);
  static DateTime? parseCreateDeletedAt(
    Mutation$CreateDelivery$createDelivery model,
  ) => _parseDeletedAt(model.deletedAt);

  static int parseGetId(Query$GetDelivery$getDelivery model) =>
      int.parse(model.id);
  static int parseGetCartId(Query$GetDelivery$getDelivery model) =>
      int.parse(model.cartId);
  static int? parseGetDeliveryTimeId(Query$GetDelivery$getDelivery model) =>
      _parseOptionalId(model.deliveryTimeId);
  static DateTime parseGetCreatedAt(Query$GetDelivery$getDelivery model) =>
      DateTime.parse(model.createdAt);
  static DateTime parseGetUpdatedAt(Query$GetDelivery$getDelivery model) =>
      DateTime.parse(model.updatedAt);
  static DateTime? parseGetDeletedAt(Query$GetDelivery$getDelivery model) =>
      _parseDeletedAt(model.deletedAt);

  static int parseListId(Query$GetDeliveries$getDeliveries model) =>
      int.parse(model.id);
  static int parseListCartId(Query$GetDeliveries$getDeliveries model) =>
      int.parse(model.cartId);
  static int? parseListDeliveryTimeId(
    Query$GetDeliveries$getDeliveries model,
  ) => _parseOptionalId(model.deliveryTimeId);
  static DateTime parseListCreatedAt(Query$GetDeliveries$getDeliveries model) =>
      DateTime.parse(model.createdAt);
  static DateTime parseListUpdatedAt(Query$GetDeliveries$getDeliveries model) =>
      DateTime.parse(model.updatedAt);
  static DateTime? parseListDeletedAt(
    Query$GetDeliveries$getDeliveries model,
  ) => _parseDeletedAt(model.deletedAt);

  static int parseUpdateId(Mutation$UpdateDelivery$updateDelivery model) =>
      int.parse(model.id);
  static int parseUpdateCartId(Mutation$UpdateDelivery$updateDelivery model) =>
      int.parse(model.cartId);
  static int? parseUpdateDeliveryTimeId(
    Mutation$UpdateDelivery$updateDelivery model,
  ) => _parseOptionalId(model.deliveryTimeId);
  static DateTime parseUpdateCreatedAt(
    Mutation$UpdateDelivery$updateDelivery model,
  ) => DateTime.parse(model.createdAt);
  static DateTime parseUpdateUpdatedAt(
    Mutation$UpdateDelivery$updateDelivery model,
  ) => DateTime.parse(model.updatedAt);
  static DateTime? parseUpdateDeletedAt(
    Mutation$UpdateDelivery$updateDelivery model,
  ) => _parseDeletedAt(model.deletedAt);

  static int? _parseOptionalId(String? value) =>
      value == null ? null : int.parse(value);

  static DateTime? _parseDeletedAt(String? value) =>
      value == null ? null : DateTime.parse(value);
}
