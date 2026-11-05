import 'package:auto_mappr_annotation/auto_mappr_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/payment.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_payment.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_payment.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_payments.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/update_payment.graphql.dart';

import 'payment_mapper.auto_mappr.dart';

@lazySingleton
@AutoMappr([
  MapType<Mutation$CreatePayment$createPayment, PaymentEntity>(
    fields: [
      Field.custom(
        'id',
        custom: PaymentGraphModelToEntityMapper.parseCreateId,
      ),
      Field.custom(
        'cartId',
        custom: PaymentGraphModelToEntityMapper.parseCreateCartId,
      ),
      Field.custom(
        'createdAt',
        custom: PaymentGraphModelToEntityMapper.parseCreateCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: PaymentGraphModelToEntityMapper.parseCreateUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: PaymentGraphModelToEntityMapper.parseCreateDeletedAt,
      ),
    ],
  ),
  MapType<Query$GetPayment$getPayment, PaymentEntity>(
    fields: [
      Field.custom('id', custom: PaymentGraphModelToEntityMapper.parseGetId),
      Field.custom(
        'cartId',
        custom: PaymentGraphModelToEntityMapper.parseGetCartId,
      ),
      Field.custom(
        'createdAt',
        custom: PaymentGraphModelToEntityMapper.parseGetCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: PaymentGraphModelToEntityMapper.parseGetUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: PaymentGraphModelToEntityMapper.parseGetDeletedAt,
      ),
    ],
  ),
  MapType<Query$GetPayments$getPayments, PaymentEntity>(
    fields: [
      Field.custom('id', custom: PaymentGraphModelToEntityMapper.parseListId),
      Field.custom(
        'cartId',
        custom: PaymentGraphModelToEntityMapper.parseListCartId,
      ),
      Field.custom(
        'createdAt',
        custom: PaymentGraphModelToEntityMapper.parseListCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: PaymentGraphModelToEntityMapper.parseListUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: PaymentGraphModelToEntityMapper.parseListDeletedAt,
      ),
    ],
  ),
  MapType<Mutation$UpdatePayment$updatePayment, PaymentEntity>(
    fields: [
      Field.custom(
        'id',
        custom: PaymentGraphModelToEntityMapper.parseUpdateId,
      ),
      Field.custom(
        'cartId',
        custom: PaymentGraphModelToEntityMapper.parseUpdateCartId,
      ),
      Field.custom(
        'createdAt',
        custom: PaymentGraphModelToEntityMapper.parseUpdateCreatedAt,
      ),
      Field.custom(
        'updatedAt',
        custom: PaymentGraphModelToEntityMapper.parseUpdateUpdatedAt,
      ),
      Field.custom(
        'deletedAt',
        custom: PaymentGraphModelToEntityMapper.parseUpdateDeletedAt,
      ),
    ],
  ),
])
class PaymentGraphModelToEntityMapper extends $PaymentGraphModelToEntityMapper {
  static int parseCreateId(Mutation$CreatePayment$createPayment model) =>
      int.parse(model.id);
  static int parseCreateCartId(Mutation$CreatePayment$createPayment model) =>
      int.parse(model.cartId);
  static DateTime parseCreateCreatedAt(
    Mutation$CreatePayment$createPayment model,
  ) => DateTime.parse(model.createdAt);
  static DateTime parseCreateUpdatedAt(
    Mutation$CreatePayment$createPayment model,
  ) => DateTime.parse(model.updatedAt);
  static DateTime? parseCreateDeletedAt(
    Mutation$CreatePayment$createPayment model,
  ) => _parseDeletedAt(model.deletedAt);

  static int parseGetId(Query$GetPayment$getPayment model) =>
      int.parse(model.id);
  static int parseGetCartId(Query$GetPayment$getPayment model) =>
      int.parse(model.cartId);
  static DateTime parseGetCreatedAt(Query$GetPayment$getPayment model) =>
      DateTime.parse(model.createdAt);
  static DateTime parseGetUpdatedAt(Query$GetPayment$getPayment model) =>
      DateTime.parse(model.updatedAt);
  static DateTime? parseGetDeletedAt(Query$GetPayment$getPayment model) =>
      _parseDeletedAt(model.deletedAt);

  static int parseListId(Query$GetPayments$getPayments model) =>
      int.parse(model.id);
  static int parseListCartId(Query$GetPayments$getPayments model) =>
      int.parse(model.cartId);
  static DateTime parseListCreatedAt(Query$GetPayments$getPayments model) =>
      DateTime.parse(model.createdAt);
  static DateTime parseListUpdatedAt(Query$GetPayments$getPayments model) =>
      DateTime.parse(model.updatedAt);
  static DateTime? parseListDeletedAt(Query$GetPayments$getPayments model) =>
      _parseDeletedAt(model.deletedAt);

  static int parseUpdateId(Mutation$UpdatePayment$updatePayment model) =>
      int.parse(model.id);
  static int parseUpdateCartId(Mutation$UpdatePayment$updatePayment model) =>
      int.parse(model.cartId);
  static DateTime parseUpdateCreatedAt(
    Mutation$UpdatePayment$updatePayment model,
  ) => DateTime.parse(model.createdAt);
  static DateTime parseUpdateUpdatedAt(
    Mutation$UpdatePayment$updatePayment model,
  ) => DateTime.parse(model.updatedAt);
  static DateTime? parseUpdateDeletedAt(
    Mutation$UpdatePayment$updatePayment model,
  ) => _parseDeletedAt(model.deletedAt);

  static DateTime? _parseDeletedAt(String? value) =>
      value == null ? null : DateTime.parse(value);
}
