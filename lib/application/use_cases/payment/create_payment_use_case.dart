import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/i_usecase.dart';
import 'package:refreshi_test/domain/entities/payment.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/interfaces/repositories/i_payment_repository.dart';

@LazySingleton()
class CreatePaymentUseCase implements UseCase<PaymentEntity, PaymentEntity> {
  CreatePaymentUseCase(this.repository);

  final IPaymentRepository repository;

  @override
  TaskEither<BaseFailure, PaymentEntity> call(PaymentEntity params) {
    return repository.createPayment(params);
  }
}
