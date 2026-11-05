import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/i_usecase.dart';
import 'package:refreshi_test/application/use_cases/no_params.dart';
import 'package:refreshi_test/domain/entities/payment.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/interfaces/repositories/i_payment_repository.dart';

@LazySingleton()
class GetPaymentsUseCase implements UseCase<List<PaymentEntity>, NoParams> {
  GetPaymentsUseCase(this.repository);

  final IPaymentRepository repository;

  @override
  TaskEither<BaseFailure, List<PaymentEntity>> call(NoParams params) {
    return repository.getPayments();
  }
}
