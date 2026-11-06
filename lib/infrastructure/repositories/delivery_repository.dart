import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/delivery.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/interfaces/repositories/i_delivery_repository.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/clients/delivery_graph_client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_delivery.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_deliveries.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_delivery.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/update_delivery.graphql.dart';
import 'package:refreshi_test/infrastructure/mappers/delivery/delivery_mapper.dart';
import 'package:refreshi_test/infrastructure/mappers/map_delivery_error.dart';
import 'package:refreshi_test/infrastructure/shared/map_graph_model.dart';

@LazySingleton(as: IDeliveryRepository)
class DeliveryRepository implements IDeliveryRepository {
  DeliveryRepository(this._client, this._mapper);

  final DeliveryGraphClient _client;
  final DeliveryGraphModelToEntityMapper _mapper;

  @override
  TaskEither<BaseFailure, DeliveryEntity> createDelivery(
    DeliveryEntity entity,
  ) {
    return _client
        .createDelivery(entity)
        .flatMap(
          (model) =>
              GraphModelMapper.mapCreate<
                Mutation$CreateDelivery$createDelivery,
                DeliveryEntity
              >(
                model,
                mapper: _mapper,
                parseErrorType: GraphQlErrorType.deliveryParseError,
              ),
        )
        .mapLeft((error) => error.toDeliveryFailure());
  }

  @override
  TaskEither<BaseFailure, DeliveryEntity> getDelivery(int id) {
    return _client
        .getDelivery(id)
        .flatMap(
          (model) =>
              GraphModelMapper.mapGet<
                Query$GetDelivery$getDelivery,
                DeliveryEntity
              >(
                model,
                mapper: _mapper,
                parseErrorType: GraphQlErrorType.deliveryParseError,
              ),
        )
        .mapLeft((error) => error.toDeliveryFailure());
  }

  @override
  TaskEither<BaseFailure, List<DeliveryEntity>> getDeliveries() {
    return _client
        .getDeliveries()
        .flatMap(
          (items) => TaskEither.traverseList(
            items,
            (model) =>
                GraphModelMapper.mapListItem<
                  Query$GetDeliveries$getDeliveries,
                  DeliveryEntity
                >(
                  model,
                  mapper: _mapper,
                  parseErrorType: GraphQlErrorType.deliveryParseError,
                ),
          ),
        )
        .mapLeft((error) => error.toDeliveryFailure());
  }

  @override
  TaskEither<BaseFailure, DeliveryEntity> updateDelivery(
    DeliveryEntity entity,
  ) {
    return _client
        .updateDelivery(entity)
        .flatMap(
          (model) =>
              GraphModelMapper.mapUpdate<
                Mutation$UpdateDelivery$updateDelivery,
                DeliveryEntity
              >(
                model,
                mapper: _mapper,
                parseErrorType: GraphQlErrorType.deliveryParseError,
              ),
        )
        .mapLeft((error) => error.toDeliveryFailure());
  }

  @override
  TaskEither<BaseFailure, Unit> deleteDelivery(int id) {
    return _client
        .deleteDelivery(id)
        .mapLeft((error) => error.toDeliveryFailure());
  }
}
