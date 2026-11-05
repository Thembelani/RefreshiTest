import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/domain/entities/payment.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/graphql_client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_payment.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/delete_payment.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_payment.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/get_payments.graphql.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/update_payment.graphql.dart';

@lazySingleton
class PaymentGraphClient {
  PaymentGraphClient(this._graphql);

  final GraphqlClient _graphql;

  TaskEither<BaseGraphError, Mutation$CreatePayment$createPayment>
  createPayment(PaymentEntity entity) {
    return TaskEither.tryCatch(
      () => _graphql.client.mutate$CreatePayment(
        Options$Mutation$CreatePayment(
          variables: Variables$Mutation$CreatePayment(
            cartId: '${entity.cartId}',
            token: entity.token,
          ),
        ),
      ),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.paymentError,
      ),
    ).map((res) => res.parsedData!.createPayment);
  }

  TaskEither<BaseGraphError, Query$GetPayment$getPayment> getPayment(int id) {
    return TaskEither.tryCatch(
      () => _graphql.client.query$GetPayment(
        Options$Query$GetPayment(
          variables: Variables$Query$GetPayment(id: '$id'),
        ),
      ),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.paymentError,
      ),
    ).map((res) {
      final payment = res.parsedData?.getPayment;
      if (payment == null) {
        throw StateError('Payment $id not found');
      }
      return payment;
    });
  }

  TaskEither<BaseGraphError, List<Query$GetPayments$getPayments>>
  getPayments() {
    return TaskEither.tryCatch(
      () => _graphql.client.query$GetPayments(),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.paymentError,
      ),
    ).map((res) => res.parsedData!.getPayments);
  }

  TaskEither<BaseGraphError, Mutation$UpdatePayment$updatePayment>
  updatePayment(PaymentEntity entity) {
    return TaskEither.tryCatch(
      () => _graphql.client.mutate$UpdatePayment(
        Options$Mutation$UpdatePayment(
          variables: Variables$Mutation$UpdatePayment(
            id: '${entity.id}',
            token: entity.token,
            deletedAt: entity.deletedAt?.toUtc().toIso8601String(),
            fulfilled: entity.fulfilled,
          ),
        ),
      ),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.paymentError,
      ),
    ).map((res) => res.parsedData!.updatePayment);
  }

  TaskEither<BaseGraphError, Unit> deletePayment(int id) {
    return TaskEither.tryCatch(
      () => _graphql.client.mutate$DeletePayment(
        Options$Mutation$DeletePayment(
          variables: Variables$Mutation$DeletePayment(id: '$id'),
        ),
      ),
      (error, stackTrace) => BaseGraphError(
        error: error,
        stackTrace: stackTrace,
        type: GraphQlErrorType.paymentError,
      ),
    ).map((res) {
      if (res.parsedData?.deletePayment != true) {
        throw StateError('Payment $id was not deleted');
      }
      return unit;
    });
  }
}
