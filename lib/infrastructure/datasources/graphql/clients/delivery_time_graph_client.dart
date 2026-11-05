import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/graphql_client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_delivery_times.graphql.dart';

@lazySingleton
class DeliveryTimeGraphClient {
  DeliveryTimeGraphClient(this._graphql);

  final GraphqlClient _graphql;

  TaskEither<BaseGraphError, List<Query$GetDeliveryTimes$getDeliveryTimes>>
  getDeliveryTimes() {
    return TaskEither.tryCatch(
      () => _graphql.client.query$GetDeliveryTimes(),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.deliveryTimeError,
      ),
    ).map((res) => res.parsedData!.getDeliveryTimes);
  }
}
