import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/cart/get_cart_use_case.dart';
import 'package:refreshi_test/application/use_cases/cart_item/get_cart_items_use_case.dart';
import 'package:refreshi_test/application/use_cases/delivery/get_deliveries_use_case.dart';
import 'package:refreshi_test/application/use_cases/no_params.dart';
import 'package:refreshi_test/application/use_cases/payment/get_payments_use_case.dart';
import 'package:refreshi_test/application/use_cases/payment/update_payment_use_case.dart';
import 'package:refreshi_test/domain/entities/cart.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/domain/entities/delivery.dart';
import 'package:refreshi_test/domain/entities/payment.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';

part 'order_summary_event.dart';
part 'order_summary_state.dart';
part 'order_summary_bloc.freezed.dart';

const _fulfillmentDelay = Duration(seconds: 10);

@lazySingleton
class OrderSummaryBloc extends Bloc<OrderSummaryEvent, OrderSummaryState> {
  OrderSummaryBloc(
    this._getCartUseCase,
    this._getCartItemsUseCase,
    this._getDeliveriesUseCase,
    this._getPaymentsUseCase,
    this._updatePaymentUseCase,
  ) : super(const OrderSummaryState()) {
    on<OrderSummaryEvent>((event, emit) async {
      await event.when(
        load: (cartId) => _load(emit, cartId),
        fulfillPayment: () => _fulfillPayment(emit),
      );
    });
  }

  final GetCartUseCase _getCartUseCase;
  final GetCartItemsUseCase _getCartItemsUseCase;
  final GetDeliveriesUseCase _getDeliveriesUseCase;
  final GetPaymentsUseCase _getPaymentsUseCase;
  final UpdatePaymentUseCase _updatePaymentUseCase;

  Future<void> _load(Emitter<OrderSummaryState> emit, int cartId) async {
    emit(state.copyWith(status: DataStatus.loading, failure: null));

    final cartResult = await _getCartUseCase.call(cartId).run();
    final BaseFailure? cartFailure = cartResult.fold(
      (error) => error,
      (_) => null,
    );
    if (cartFailure != null) {
      emit(
        state.copyWith(
          cart: null,
          items: const [],
          delivery: null,
          payment: null,
          failure: cartFailure,
          status: DataStatus.error,
        ),
      );
      return;
    }
    final cart = cartResult.fold((_) => null, (entity) => entity);
    if (cart == null) {
      return;
    }

    final itemsResult = await _getCartItemsUseCase.call(const NoParams()).run();
    final BaseFailure? itemsFailure = itemsResult.fold(
      (error) => error,
      (_) => null,
    );
    if (itemsFailure != null) {
      emit(
        state.copyWith(
          cart: cart,
          items: const [],
          delivery: null,
          payment: null,
          failure: itemsFailure,
          status: DataStatus.error,
        ),
      );
      return;
    }

    final deliveriesResult = await _getDeliveriesUseCase
        .call(const NoParams())
        .run();
    final BaseFailure? deliveriesFailure = deliveriesResult.fold(
      (error) => error,
      (_) => null,
    );
    if (deliveriesFailure != null) {
      emit(
        state.copyWith(
          cart: cart,
          items: _itemsForCart(
            itemsResult.fold((_) => const [], (items) => items),
            cartId,
          ),
          delivery: null,
          payment: null,
          failure: deliveriesFailure,
          status: DataStatus.error,
        ),
      );
      return;
    }

    final paymentsResult = await _getPaymentsUseCase
        .call(const NoParams())
        .run();
    final BaseFailure? paymentsFailure = paymentsResult.fold(
      (error) => error,
      (_) => null,
    );
    if (paymentsFailure != null) {
      emit(
        state.copyWith(
          cart: cart,
          items: _itemsForCart(
            itemsResult.fold((_) => const [], (items) => items),
            cartId,
          ),
          delivery: _deliveryForCart(
            deliveriesResult.fold((_) => const [], (items) => items),
            cartId,
          ),
          payment: null,
          failure: paymentsFailure,
          status: DataStatus.error,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        cart: cart,
        items: _itemsForCart(
          itemsResult.fold((_) => const [], (items) => items),
          cartId,
        ),
        delivery: _deliveryForCart(
          deliveriesResult.fold((_) => const [], (items) => items),
          cartId,
        ),
        payment: _paymentForCart(
          paymentsResult.fold((_) => const [], (items) => items),
          cartId,
        ),
        failure: null,
        status: DataStatus.success,
      ),
    );
  }

  Future<void> _fulfillPayment(Emitter<OrderSummaryState> emit) async {
    final payment = state.payment;
    if (payment == null || payment.fulfilled || state.fulfillmentRequested) {
      return;
    }

    emit(state.copyWith(fulfillmentRequested: true));
    await Future.delayed(_fulfillmentDelay);

    final current = state.payment;
    if (current == null || current.fulfilled) {
      return;
    }

    final now = DateTime.now();
    final result = await _updatePaymentUseCase
        .call(
          PaymentEntity(
            id: current.id,
            cartId: current.cartId,
            token: current.token,
            fulfilled: true,
            createdAt: current.createdAt,
            updatedAt: now,
            deletedAt: current.deletedAt,
          ),
        )
        .run();

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure,
          status: DataStatus.error,
          fulfillmentRequested: false,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          payment: updated,
          failure: null,
          status: DataStatus.success,
        ),
      ),
    );
  }

  List<CartItemEntity> _itemsForCart(List<CartItemEntity> items, int cartId) {
    return [
      for (final item in items)
        if (item.cartId == cartId) item,
    ];
  }

  DeliveryEntity? _deliveryForCart(
    List<DeliveryEntity> deliveries,
    int cartId,
  ) {
    DeliveryEntity? match;
    for (final delivery in deliveries) {
      if (delivery.cartId == cartId && delivery.deletedAt == null) {
        if (match == null || delivery.id > match.id) {
          match = delivery;
        }
      }
    }
    return match;
  }

  PaymentEntity? _paymentForCart(List<PaymentEntity> payments, int cartId) {
    PaymentEntity? match;
    for (final payment in payments) {
      if (payment.cartId == cartId && payment.deletedAt == null) {
        if (match == null || payment.id > match.id) {
          match = payment;
        }
      }
    }
    return match;
  }
}
