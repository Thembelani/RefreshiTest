import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/i_usecase.dart';
import 'package:refreshi_test/application/use_cases/no_params.dart';
import 'package:refreshi_test/domain/entities/delivery_time.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/domain/interfaces/repositories/i_delivery_time_repository.dart';

@LazySingleton()
class GetDeliveryTimesUseCase
    implements UseCase<List<DeliveryTimeEntity>, NoParams> {
  GetDeliveryTimesUseCase(this.repository);

  final IDeliveryTimeRepository repository;

  @override
  TaskEither<BaseFailure, List<DeliveryTimeEntity>> call(NoParams params) {
    return repository.getDeliveryTimes();
  }
}
