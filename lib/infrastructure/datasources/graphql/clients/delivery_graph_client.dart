import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/delivery.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/graphql_client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_delivery.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/delete_delivery.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_deliveries.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_delivery.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/update_delivery.graphql.dart';

@lazySingleton
class DeliveryGraphClient {
  DeliveryGraphClient(this._graphql);

  final GraphqlClient _graphql;

  TaskEither<BaseGraphError, Mutation$CreateDelivery$createDelivery>
  createDelivery(DeliveryEntity entity) {
    return TaskEither.tryCatch(
      () => _graphql.client.mutate$CreateDelivery(
        Options$Mutation$CreateDelivery(
          variables: Variables$Mutation$CreateDelivery(
            cartId: '${entity.cartId}',
            street: entity.street,
            city: entity.city,
            postalCode: entity.postalCode,
            deliveryTimeId: entity.deliveryTimeId?.toString(),
          ),
        ),
      ),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.deliveryError,
      ),
    ).map((res) => res.parsedData!.createDelivery);
  }

  TaskEither<BaseGraphError, Query$GetDelivery$getDelivery> getDelivery(
    int id,
  ) {
    return TaskEither.tryCatch(
      () => _graphql.client.query$GetDelivery(
        Options$Query$GetDelivery(
          variables: Variables$Query$GetDelivery(id: '$id'),
        ),
      ),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.deliveryError,
      ),
    ).map((res) {
      final delivery = res.parsedData?.getDelivery;
      if (delivery == null) {
        throw StateError('Delivery $id not found');
      }
      return delivery;
    });
  }

  TaskEither<BaseGraphError, List<Query$GetDeliveries$getDeliveries>>
  getDeliveries() {
    return TaskEither.tryCatch(
      () => _graphql.client.query$GetDeliveries(),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.deliveryError,
      ),
    ).map((res) => res.parsedData!.getDeliveries);
  }

  TaskEither<BaseGraphError, Mutation$UpdateDelivery$updateDelivery>
  updateDelivery(DeliveryEntity entity) {
    return TaskEither.tryCatch(
      () => _graphql.client.mutate$UpdateDelivery(
        Options$Mutation$UpdateDelivery(
          variables: Variables$Mutation$UpdateDelivery(
            id: '${entity.id}',
            street: entity.street,
            city: entity.city,
            postalCode: entity.postalCode,
            deliveryTimeId: entity.deliveryTimeId?.toString(),
            deletedAt: entity.deletedAt?.toUtc().toIso8601String(),
          ),
        ),
      ),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.deliveryError,
      ),
    ).map((res) => res.parsedData!.updateDelivery);
  }

  TaskEither<BaseGraphError, Unit> deleteDelivery(int id) {
    return TaskEither.tryCatch(
      () => _graphql.client.mutate$DeleteDelivery(
        Options$Mutation$DeleteDelivery(
          variables: Variables$Mutation$DeleteDelivery(id: '$id'),
        ),
      ),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.deliveryError,
      ),
    ).map((res) {
      if (res.parsedData?.deleteDelivery != true) {
        throw StateError('Delivery $id was not deleted');
      }
      return unit;
    });
  }
}
