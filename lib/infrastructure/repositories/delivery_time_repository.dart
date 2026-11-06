import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/delivery_time.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/interfaces/repositories/i_delivery_time_repository.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/clients/delivery_time_graph_client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_delivery_times.graphql.dart';
import 'package:refreshi_test/infrastructure/mappers/delivery_time/delivery_time_mapper.dart';
import 'package:refreshi_test/infrastructure/mappers/map_delivery_time_error.dart';
import 'package:refreshi_test/infrastructure/shared/map_graph_model.dart';

@LazySingleton(as: IDeliveryTimeRepository)
class DeliveryTimeRepository implements IDeliveryTimeRepository {
  DeliveryTimeRepository(this._client, this._mapper);

  final DeliveryTimeGraphClient _client;
  final DeliveryTimeGraphModelToEntityMapper _mapper;

  @override
  TaskEither<BaseFailure, List<DeliveryTimeEntity>> getDeliveryTimes() {
    return _client
        .getDeliveryTimes()
        .flatMap(
          (items) => TaskEither.traverseList(
            items,
            (model) =>
                GraphModelMapper.mapListItem<
                  Query$GetDeliveryTimes$getDeliveryTimes,
                  DeliveryTimeEntity
                >(
                  model,
                  mapper: _mapper,
                  parseErrorType: GraphQlErrorType.deliveryTimeParseError,
                ),
          ),
        )
        .mapLeft((error) => error.toDeliveryTimeFailure());
  }
}
