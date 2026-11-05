import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/i_usecase.dart';
import 'package:refreshi_test/application/use_cases/no_params.dart';
import 'package:refreshi_test/domain/entities/delivery.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/interfaces/repositories/i_delivery_repository.dart';

@LazySingleton()
class GetDeliveriesUseCase implements UseCase<List<DeliveryEntity>, NoParams> {
  GetDeliveriesUseCase(this.repository);

  final IDeliveryRepository repository;

  @override
  TaskEither<BaseFailure, List<DeliveryEntity>> call(NoParams params) {
    return repository.getDeliveries();
  }
}
