import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/delivery_time.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_delivery_times.graphql.dart';

import 'delivery_time_mapper.auto_mappr.dart';

@lazySingleton
@AutoMappr([
  MapType<Query$GetDeliveryTimes$getDeliveryTimes, DeliveryTimeEntity>(
    fields: [
      Field.custom('id', custom: DeliveryTimeGraphModelToEntityMapper.parseId),
      Field.custom(
        'createdAt',
        custom: DeliveryTimeGraphModelToEntityMapper.parseCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: DeliveryTimeGraphModelToEntityMapper.parseUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: DeliveryTimeGraphModelToEntityMapper.parseDeletedAt,
      ),
    ],
  ),
])
class DeliveryTimeGraphModelToEntityMapper
    extends $DeliveryTimeGraphModelToEntityMapper {
  static int parseId(Query$GetDeliveryTimes$getDeliveryTimes model) =>
      int.parse(model.id);

  static DateTime parseCreatedAt(
    Query$GetDeliveryTimes$getDeliveryTimes model,
  ) => DateTime.parse(model.createdAt);

  static DateTime parseUpdatedAt(
    Query$GetDeliveryTimes$getDeliveryTimes model,
  ) => DateTime.parse(model.updatedAt);

  static DateTime? parseDeletedAt(
    Query$GetDeliveryTimes$getDeliveryTimes model,
  ) => model.deletedAt == null ? null : DateTime.parse(model.deletedAt!);
}
