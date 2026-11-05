import 'package:fpdart/fpdart.dart';
import 'package:refreshi_test/domain/entities/delivery_time.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';

abstract class IDeliveryTimeRepository {
  TaskEither<BaseFailure, List<DeliveryTimeEntity>> getDeliveryTimes();
}
