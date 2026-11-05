import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:refreshi_test/application/use_cases/no_params.dart';
import 'package:refreshi_test/domain/entities/cart.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/domain/entities/delivery.dart';
import 'package:refreshi_test/domain/entities/payment.dart';
import 'package:refreshi_test/domain/failures/cart_failures.dart';
import 'package:refreshi_test/presentation/state/bloc/order_summary/order_summary_bloc.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';

import '../../../../mocks.dart';

void main() {
  final now = DateTime.utc(2026, 1, 1);
  final cart = CartEntity(id: 3, createdAt: now, updatedAt: now, placedAt: now);
  final otherItem = CartItemEntity(
    id: 1,
    cartId: 1,
    catalogItemId: 1,
    quantity: 9,
    createdAt: now,
    updatedAt: now,
  );
  final item = CartItemEntity(
    id: 2,
    cartId: 3,
    catalogItemId: 4,
    quantity: 2,
    createdAt: now,
    updatedAt: now,
  );
  final otherDelivery = DeliveryEntity(
    id: 1,
    cartId: 1,
    street: 'Other',
    city: 'Joburg',
    postalCode: '2000',
    createdAt: now,
    updatedAt: now,
  );
  final delivery = DeliveryEntity(
    id: 2,
    cartId: 3,
    street: '12 Long Street',
    city: 'Cape Town',
    postalCode: '8001',
    createdAt: now,
    updatedAt: now,
  );
  final otherPayment = PaymentEntity(
    id: 1,
    cartId: 1,
    token: 'tok_other',
    createdAt: now,
    updatedAt: now,
  );
  final payment = PaymentEntity(
    id: 2,
    cartId: 3,
    token: 'tok_visa_4242',
    createdAt: now,
    updatedAt: now,
  );

  late MockGetCartUseCase getCart;
  late MockGetCartItemsUseCase getCartItems;
  late MockGetDeliveriesUseCase getDeliveries;
  late MockGetPaymentsUseCase getPayments;
  late MockUpdatePaymentUseCase updatePayment;
  late OrderSummaryBloc bloc;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(payment);
  });

  setUp(() {
    getCart = MockGetCartUseCase();
    getCartItems = MockGetCartItemsUseCase();
    getDeliveries = MockGetDeliveriesUseCase();
    getPayments = MockGetPaymentsUseCase();
    updatePayment = MockUpdatePaymentUseCase();
    when(() => getCart.call(3)).thenReturn(TaskEither.right(cart));
    when(
      () => getCartItems.call(const NoParams()),
    ).thenReturn(TaskEither.right([otherItem, item]));
    when(
      () => getDeliveries.call(const NoParams()),
    ).thenReturn(TaskEither.right([otherDelivery, delivery]));
    when(
      () => getPayments.call(const NoParams()),
    ).thenReturn(TaskEither.right([otherPayment, payment]));
    when(() => updatePayment.call(any())).thenAnswer((invocation) {
      final entity = invocation.positionalArguments.first as PaymentEntity;
      return TaskEither.right(
        PaymentEntity(
          id: entity.id,
          cartId: entity.cartId,
          token: entity.token,
          fulfilled: entity.fulfilled,
          createdAt: entity.createdAt,
          updatedAt: entity.updatedAt,
          deletedAt: entity.deletedAt,
        ),
      );
    });
    bloc = OrderSummaryBloc(
      getCart,
      getCartItems,
      getDeliveries,
      getPayments,
      updatePayment,
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  test('load fetches cart 3 items, delivery, and payment by cartId', () async {
    bloc.add(const OrderSummaryEvent.load(cartId: 3));
    await pumpEventQueue();

    expect(bloc.state.cart?.id, 3);
    expect(bloc.state.items, hasLength(1));
    expect(bloc.state.items.first.id, 2);
    expect(bloc.state.delivery?.id, 2);
    expect(bloc.state.payment?.id, 2);
    expect(bloc.state.payment?.fulfilled, isFalse);
    expect(bloc.state.status, DataStatus.success);
    verify(() => getCart.call(3)).called(1);
    verify(() => getCartItems.call(const NoParams())).called(1);
    verify(() => getPayments.call(const NoParams())).called(1);
  });

  test('load then fulfillPayment waits 10s and sets fulfilled once', () {
    fakeAsync((async) {
      final bloc = OrderSummaryBloc(
        getCart,
        getCartItems,
        getDeliveries,
        getPayments,
        updatePayment,
      );

      bloc.add(const OrderSummaryEvent.load(cartId: 3));
      async.flushMicrotasks();
      bloc.add(const OrderSummaryEvent.fulfillPayment());
      async.flushMicrotasks();

      expect(bloc.state.payment?.fulfilled, isFalse);
      expect(bloc.state.fulfillmentRequested, isTrue);
      verifyNever(() => updatePayment.call(any()));

      async.elapse(const Duration(seconds: 10));
      async.flushMicrotasks();

      expect(bloc.state.payment?.fulfilled, isTrue);
      expect(bloc.state.isFulfilled, isTrue);
      verify(() => updatePayment.call(any())).called(1);

      bloc.add(const OrderSummaryEvent.fulfillPayment());
      async.flushMicrotasks();
      expect(bloc.state.payment?.fulfilled, isTrue);

      bloc.close();
      async.flushMicrotasks();
    });
  });

  test('load emits error when getCart fails', () async {
    when(() => getCart.call(3)).thenReturn(TaskEither.left(CartFailure()));

    bloc.add(const OrderSummaryEvent.load(cartId: 3));
    await pumpEventQueue();

    expect(bloc.state.status, DataStatus.error);
    expect(bloc.state.failure, isA<CartFailure>());
    expect(bloc.state.cart, isNull);
    verifyNever(() => getCartItems.call(const NoParams()));
  });
}
