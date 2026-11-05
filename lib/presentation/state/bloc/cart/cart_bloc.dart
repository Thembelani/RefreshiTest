import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/cart/create_cart_use_case.dart';
import 'package:refreshi_test/application/use_cases/cart/update_cart_use_case.dart';
import 'package:refreshi_test/application/use_cases/cart_item/create_cart_item_use_case.dart';
import 'package:refreshi_test/application/use_cases/cart_item/update_cart_item_use_case.dart';
import 'package:refreshi_test/application/use_cases/delivery/create_delivery_use_case.dart';
import 'package:refreshi_test/application/use_cases/delivery/update_delivery_use_case.dart';
import 'package:refreshi_test/application/use_cases/payment/create_payment_use_case.dart';
import 'package:refreshi_test/domain/entities/cart.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/domain/entities/delivery.dart';
import 'package:refreshi_test/domain/entities/payment.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';

part 'cart_event.dart';
part 'cart_state.dart';
part 'cart_bloc.freezed.dart';

const _dummyStreet = '12 Long Street';
const _dummyCity = 'Cape Town';
const _dummyPostalCode = '8001';
const _dummyPaymentToken = 'tok_visa_4242';

@lazySingleton
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(
    this._createCartUseCase,
    this._updateCartUseCase,
    this._createCartItemUseCase,
    this._updateCartItemUseCase,
    this._createDeliveryUseCase,
    this._updateDeliveryUseCase,
    this._createPaymentUseCase,
  ) : super(const CartState()) {
    on<CartEvent>((event, emit) async {
      await event.when(
        startCart: () => _startCart(emit),
        addCatalogItem: (catalogItemId) => _addCatalogItem(emit, catalogItemId),
        decrementCatalogItem: (catalogItemId) =>
            _decrementCatalogItem(emit, catalogItemId),
        removeCartItem: (cartItemId) => _removeCartItem(emit, cartItemId),
        prepareCheckout: () => _prepareCheckout(emit),
        ensureCheckoutDetails: () => _ensureCheckoutDetails(emit),
        selectDeliveryTime: (deliveryTimeId) =>
            _selectDeliveryTime(emit, deliveryTimeId),
        placeOrder: () => _placeOrder(emit),
      );
    });
  }

  final CreateCartUseCase _createCartUseCase;
  final UpdateCartUseCase _updateCartUseCase;
  final CreateCartItemUseCase _createCartItemUseCase;
  final UpdateCartItemUseCase _updateCartItemUseCase;
  final CreateDeliveryUseCase _createDeliveryUseCase;
  final UpdateDeliveryUseCase _updateDeliveryUseCase;
  final CreatePaymentUseCase _createPaymentUseCase;

  Future<void> _startCart(Emitter<CartState> emit) async {
    emit(
      state.copyWith(
        status: DataStatus.loading,
        checkoutPrepared: false,
        failure: null,
      ),
    );

    final now = DateTime.now();
    final result = await _createCartUseCase
        .call(
          CartEntity(id: 0, createdAt: now, updatedAt: now),
        )
        .run();

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure,
          status: DataStatus.error,
          checkoutPrepared: false,
        ),
      ),
      (cart) => emit(
        CartState(
          cart: cart,
          items: const [],
          status: DataStatus.success,
        ),
      ),
    );
  }

  Future<void> _addCatalogItem(
    Emitter<CartState> emit,
    int catalogItemId,
  ) async {
    final cart = state.cart;
    if (cart == null) {
      return;
    }

    final existing = _itemForCatalog(catalogItemId);
    if (existing == null) {
      await _createItem(emit, cart.id, catalogItemId);
      return;
    }

    await _updateItem(
      emit,
      _copyItem(
        existing,
        quantity: existing.quantity + 1,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> _decrementCatalogItem(
    Emitter<CartState> emit,
    int catalogItemId,
  ) async {
    final existing = _itemForCatalog(catalogItemId);
    if (existing == null || existing.quantity <= 0) {
      return;
    }

    await _updateItem(
      emit,
      _copyItem(
        existing,
        quantity: existing.quantity - 1,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> _removeCartItem(Emitter<CartState> emit, int cartItemId) async {
    CartItemEntity? existing;
    for (final item in state.items) {
      if (item.id == cartItemId && item.deletedAt == null) {
        existing = item;
        break;
      }
    }
    if (existing == null) {
      return;
    }

    final now = DateTime.now();
    await _updateItem(
      emit,
      _copyItem(existing, deletedAt: now, updatedAt: now),
    );
  }

  Future<void> _prepareCheckout(Emitter<CartState> emit) async {
    emit(
      state.copyWith(
        status: DataStatus.loading,
        checkoutPrepared: false,
        failure: null,
      ),
    );

    var items = [...state.items];
    final now = DateTime.now();
    final toDelete = items
        .where((item) => item.quantity == 0 && item.deletedAt == null)
        .toList();

    for (final item in toDelete) {
      final pending = _copyItem(item, deletedAt: now, updatedAt: now);
      final result = await _updateCartItemUseCase.call(pending).run();
      final BaseFailure? failure = result.fold((error) => error, (_) => null);
      if (failure != null) {
        emit(
          state.copyWith(
            failure: failure,
            status: DataStatus.error,
            checkoutPrepared: false,
          ),
        );
        return;
      }
      final updated = result.fold((_) => pending, (entity) => entity);
      items = _replaceItem(items, updated);
    }

    emit(
      state.copyWith(
        items: items,
        failure: null,
        status: DataStatus.success,
      ),
    );

    final ready = await _ensureCheckoutDetails(emit);
    if (!ready) {
      return;
    }

    emit(
      state.copyWith(
        failure: null,
        status: DataStatus.success,
        checkoutPrepared: true,
      ),
    );
  }

  Future<bool> _ensureCheckoutDetails(Emitter<CartState> emit) async {
    final cart = state.cart;
    if (cart == null) {
      return false;
    }
    if (state.delivery != null && state.payment != null) {
      return true;
    }

    emit(
      state.copyWith(
        status: DataStatus.loading,
        checkoutPrepared: false,
        failure: null,
      ),
    );

    final now = DateTime.now();
    var delivery = state.delivery;
    var payment = state.payment;

    if (delivery == null) {
      final result = await _createDeliveryUseCase
          .call(
            DeliveryEntity(
              id: 0,
              cartId: cart.id,
              street: _dummyStreet,
              city: _dummyCity,
              postalCode: _dummyPostalCode,
              createdAt: now,
              updatedAt: now,
            ),
          )
          .run();
      final BaseFailure? failure = result.fold((error) => error, (_) => null);
      if (failure != null) {
        emit(
          state.copyWith(
            failure: failure,
            status: DataStatus.error,
            checkoutPrepared: false,
          ),
        );
        return false;
      }
      delivery = result.fold((_) => delivery, (entity) => entity);
    }

    if (payment == null) {
      final result = await _createPaymentUseCase
          .call(
            PaymentEntity(
              id: 0,
              cartId: cart.id,
              token: _dummyPaymentToken,
              fulfilled: false,
              createdAt: now,
              updatedAt: now,
            ),
          )
          .run();
      final BaseFailure? failure = result.fold((error) => error, (_) => null);
      if (failure != null) {
        emit(
          state.copyWith(
            delivery: delivery,
            failure: failure,
            status: DataStatus.error,
            checkoutPrepared: false,
          ),
        );
        return false;
      }
      payment = result.fold((_) => payment, (entity) => entity);
    }

    emit(
      state.copyWith(
        delivery: delivery,
        payment: payment,
        failure: null,
        status: DataStatus.success,
      ),
    );
    return true;
  }

  Future<void> _selectDeliveryTime(
    Emitter<CartState> emit,
    int deliveryTimeId,
  ) async {
    final delivery = state.delivery;
    if (delivery == null) {
      return;
    }

    emit(
      state.copyWith(
        status: DataStatus.loading,
        failure: null,
      ),
    );

    final pending = DeliveryEntity(
      id: delivery.id,
      cartId: delivery.cartId,
      street: delivery.street,
      city: delivery.city,
      postalCode: delivery.postalCode,
      deliveryTimeId: deliveryTimeId,
      createdAt: delivery.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: delivery.deletedAt,
    );

    final result = await _updateDeliveryUseCase.call(pending).run();
    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure,
          status: DataStatus.error,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          delivery: updated,
          failure: null,
          status: DataStatus.success,
        ),
      ),
    );
  }

  CartItemEntity? _itemForCatalog(int catalogItemId) {
    for (final item in state.items) {
      if (item.catalogItemId == catalogItemId && item.deletedAt == null) {
        return item;
      }
    }
    return null;
  }

  Future<void> _createItem(
    Emitter<CartState> emit,
    int cartId,
    int catalogItemId,
  ) async {
    emit(
      state.copyWith(
        status: DataStatus.loading,
        checkoutPrepared: false,
        failure: null,
      ),
    );

    final now = DateTime.now();
    final result = await _createCartItemUseCase
        .call(
          CartItemEntity(
            id: 0,
            cartId: cartId,
            catalogItemId: catalogItemId,
            quantity: 1,
            createdAt: now,
            updatedAt: now,
          ),
        )
        .run();

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure,
          status: DataStatus.error,
          checkoutPrepared: false,
        ),
      ),
      (item) => emit(
        state.copyWith(
          items: [...state.items, item],
          failure: null,
          status: DataStatus.success,
        ),
      ),
    );
  }

  Future<void> _updateItem(
    Emitter<CartState> emit,
    CartItemEntity item,
  ) async {
    emit(
      state.copyWith(
        status: DataStatus.loading,
        checkoutPrepared: false,
        failure: null,
      ),
    );

    final result = await _updateCartItemUseCase.call(item).run();
    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure,
          status: DataStatus.error,
          checkoutPrepared: false,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          items: _replaceItem(state.items, updated),
          failure: null,
          status: DataStatus.success,
        ),
      ),
    );
  }

  Future<void> _placeOrder(Emitter<CartState> emit) async {
    final cart = state.cart;
    if (cart == null ||
        cart.placedAt != null ||
        state.delivery?.deliveryTimeId == null) {
      return;
    }

    emit(
      state.copyWith(
        status: DataStatus.loading,
        failure: null,
      ),
    );

    final now = DateTime.now();
    final result = await _updateCartUseCase
        .call(
          CartEntity(
            id: cart.id,
            createdAt: cart.createdAt,
            updatedAt: now,
            placedAt: now,
            deletedAt: cart.deletedAt,
          ),
        )
        .run();

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure,
          status: DataStatus.error,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          cart: updated,
          failure: null,
          status: DataStatus.success,
        ),
      ),
    );
  }

  CartItemEntity _copyItem(
    CartItemEntity item, {
    int? quantity,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return CartItemEntity(
      id: item.id,
      cartId: item.cartId,
      catalogItemId: item.catalogItemId,
      quantity: quantity ?? item.quantity,
      createdAt: item.createdAt,
      updatedAt: updatedAt ?? item.updatedAt,
      deletedAt: deletedAt ?? item.deletedAt,
    );
  }

  List<CartItemEntity> _replaceItem(
    List<CartItemEntity> items,
    CartItemEntity updated,
  ) {
    return [
      for (final item in items)
        if (item.id == updated.id) updated else item,
    ];
  }
}
