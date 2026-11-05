import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:refreshi_test/domain/entities/payment.dart';
import 'package:refreshi_test/domain/failures/payment_failures.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/errors/base_graph_error.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/operations/create_payment.graphql.dart';
import 'package:refreshi_test/infrastructure/mappers/payment/payment_mapper.dart';
import 'package:refreshi_test/infrastructure/repositories/payment_repository.dart';

import '../../mocks.dart';

void main() {
  late MockPaymentGraphClient client;
  late PaymentRepository repository;
  final now = DateTime.utc(2026, 1, 1);
  final placeholder = PaymentEntity(
    id: 0,
    cartId: 1,
    token: 'tok_visa_4242',
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    client = MockPaymentGraphClient();
    repository = PaymentRepository(
      client,
      PaymentGraphModelToEntityMapper(),
    );
  });

  test('maps created GraphQL payment to entity', () async {
    when(() => client.createPayment(placeholder)).thenReturn(
      TaskEither.right(
        Mutation$CreatePayment$createPayment(
          id: '2',
          cartId: '1',
          token: 'tok_visa_4242',
          createdAt: '2026-01-01T00:00:00.000Z',
          updatedAt: '2026-01-01T00:00:00.000Z',
        ),
      ),
    );

    final result = await repository.createPayment(placeholder).run();

    expect(result.isRight(), isTrue);
    result.match((_) => fail('expected payment'), (payment) {
      expect(payment.id, 2);
      expect(payment.cartId, 1);
      expect(payment.token, 'tok_visa_4242');
    });
  });

  test('maps client errors to PaymentFailure', () async {
    when(() => client.createPayment(placeholder)).thenReturn(
      TaskEither.left(BaseGraphError(type: GraphQlErrorType.paymentError)),
    );

    final result = await repository.createPayment(placeholder).run();

    expect(result.isLeft(), isTrue);
    result.match(
      (failure) => expect(failure, isA<PaymentFailure>()),
      (_) => fail('expected failure'),
    );
  });
}
