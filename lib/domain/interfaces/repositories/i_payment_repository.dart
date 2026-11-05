import 'package:fpdart/fpdart.dart';
import 'package:refreshi_test/domain/entities/payment.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';

abstract class IPaymentRepository {
  TaskEither<BaseFailure, PaymentEntity> createPayment(PaymentEntity entity);
  TaskEither<BaseFailure, PaymentEntity> getPayment(int id);
  TaskEither<BaseFailure, List<PaymentEntity>> getPayments();
  TaskEither<BaseFailure, PaymentEntity> updatePayment(PaymentEntity entity);
  TaskEither<BaseFailure, Unit> deletePayment(int id);
}
