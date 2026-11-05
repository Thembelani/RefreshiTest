import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/i_usecase.dart';
import 'package:refreshi_test/domain/entities/delivery.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/interfaces/repositories/i_delivery_repository.dart';

@LazySingleton()
class UpdateDeliveryUseCase implements UseCase<DeliveryEntity, DeliveryEntity> {
  UpdateDeliveryUseCase(this.repository);

  final IDeliveryRepository repository;

  @override
  TaskEither<BaseFailure, DeliveryEntity> call(DeliveryEntity params) {
    return repository.updateDelivery(params);
  }
}
