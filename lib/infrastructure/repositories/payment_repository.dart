import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/payment.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/interfaces/repositories/i_payment_repository.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/clients/payment_graph_client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_payment.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_payment.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_payments.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/update_payment.graphql.dart';
import 'package:refreshi_test/infrastructure/mappers/map_payment_error.dart';
import 'package:refreshi_test/infrastructure/mappers/payment/payment_mapper.dart';
import 'package:refreshi_test/infrastructure/shared/map_graph_model.dart';

@LazySingleton(as: IPaymentRepository)
class PaymentRepository implements IPaymentRepository {
  PaymentRepository(this._client, this._mapper);

  final PaymentGraphClient _client;
  final PaymentGraphModelToEntityMapper _mapper;

  @override
  TaskEither<BaseFailure, PaymentEntity> createPayment(PaymentEntity entity) {
    return _client
        .createPayment(entity)
        .flatMap(
          (model) => GraphModelMapper.mapCreate<PaymentEntity,
              Mutation$CreatePayment$createPayment>(
            model,
            mapper: _mapper,
            parseErrorType: GraphQlErrorType.paymentParseError,
          ),
        )
        .mapLeft((error) => error.toPaymentFailure());
  }

  @override
  TaskEither<BaseFailure, PaymentEntity> getPayment(int id) {
    return _client
        .getPayment(id)
        .flatMap(
          (model) => GraphModelMapper.mapGet<PaymentEntity,
              Query$GetPayment$getPayment>(
            model,
            mapper: _mapper,
            parseErrorType: GraphQlErrorType.paymentParseError,
          ),
        )
        .mapLeft((error) => error.toPaymentFailure());
  }

  @override
  TaskEither<BaseFailure, List<PaymentEntity>> getPayments() {
    return _client
        .getPayments()
        .flatMap(
          (items) => TaskEither.traverseList(
            items,
            (model) => GraphModelMapper.mapListItem<PaymentEntity,
                Query$GetPayments$getPayments>(
              model,
              mapper: _mapper,
              parseErrorType: GraphQlErrorType.paymentParseError,
            ),
          ),
        )
        .mapLeft((error) => error.toPaymentFailure());
  }

  @override
  TaskEither<BaseFailure, PaymentEntity> updatePayment(PaymentEntity entity) {
    return _client
        .updatePayment(entity)
        .flatMap(
          (model) => GraphModelMapper.mapUpdate<PaymentEntity,
              Mutation$UpdatePayment$updatePayment>(
            model,
            mapper: _mapper,
            parseErrorType: GraphQlErrorType.paymentParseError,
          ),
        )
        .mapLeft((error) => error.toPaymentFailure());
  }

  @override
  TaskEither<BaseFailure, Unit> deletePayment(int id) {
    return _client
        .deletePayment(id)
        .mapLeft((error) => error.toPaymentFailure());
  }
}
