import 'package:fpdart/fpdart.dart';
import 'package:refreshi_test/domain/entities/delivery.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';

abstract class IDeliveryRepository {
  TaskEither<BaseFailure, DeliveryEntity> createDelivery(DeliveryEntity entity);
  TaskEither<BaseFailure, DeliveryEntity> getDelivery(int id);
  TaskEither<BaseFailure, List<DeliveryEntity>> getDeliveries();
  TaskEither<BaseFailure, DeliveryEntity> updateDelivery(DeliveryEntity entity);
  TaskEither<BaseFailure, Unit> deleteDelivery(int id);
}
