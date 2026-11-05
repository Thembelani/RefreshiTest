import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/application/use_cases/cart/create_cart_use_case.dart';
import 'package:refreshi_test/application/use_cases/cart_item/create_cart_item_use_case.dart';
import 'package:refreshi_test/application/use_cases/cart_item/update_cart_item_use_case.dart';
import 'package:refreshi_test/domain/entities/cart.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/domain/failures/base_failure.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';

part 'cart_event.dart';
part 'cart_state.dart';
part 'cart_bloc.freezed.dart';

@lazySingleton
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(
    this._createCartUseCase,
    this._createCartItemUseCase,
    this._updateCartItemUseCase,
  ) : super(const CartState()) {
    on<CartEvent>((event, emit) async {
      await event.when(
        startCart: () => _startCart(emit),
        addCatalogItem: (catalogItemId) => _addCatalogItem(emit, catalogItemId),
        decrementCatalogItem: (catalogItemId) =>
            _decrementCatalogItem(emit, catalogItemId),
        removeCartItem: (cartItemId) => _removeCartItem(emit, cartItemId),
        prepareCheckout: () => _prepareCheckout(emit),
      );
    });
  }

  final CreateCartUseCase _createCartUseCase;
  final CreateCartItemUseCase _createCartItemUseCase;
  final UpdateCartItemUseCase _updateCartItemUseCase;

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
        checkoutPrepared: true,
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
