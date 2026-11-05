import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:refreshi_test/domain/entities/cart.dart';
import 'package:refreshi_test/domain/entities/cart_item.dart';
import 'package:refreshi_test/domain/failures/cart_failures.dart';
import 'package:refreshi_test/presentation/state/bloc/cart/cart_bloc.dart';
import 'package:refreshi_test/presentation/state/utils/data_status.dart';

import '../../../../mocks.dart';

void main() {
  final now = DateTime.utc(2026, 1, 1);
  final cart = CartEntity(id: 1, createdAt: now, updatedAt: now);
  final cartItem = CartItemEntity(
    id: 10,
    cartId: 1,
    catalogItemId: 3,
    quantity: 1,
    createdAt: now,
    updatedAt: now,
  );

  late MockCreateCartUseCase createCart;
  late MockCreateCartItemUseCase createCartItem;
  late MockUpdateCartItemUseCase updateCartItem;
  late CartBloc bloc;

  setUpAll(() {
    registerFallbackValue(cart);
    registerFallbackValue(cartItem);
  });

  setUp(() {
    createCart = MockCreateCartUseCase();
    createCartItem = MockCreateCartItemUseCase();
    updateCartItem = MockUpdateCartItemUseCase();
    bloc = CartBloc(createCart, createCartItem, updateCartItem);
  });

  tearDown(() async {
    await bloc.close();
  });

  test('startCart emits a new empty cart', () async {
    when(() => createCart.call(any())).thenReturn(TaskEither.right(cart));

    bloc.add(const CartEvent.startCart());
    await pumpEventQueue();

    expect(bloc.state.cart?.id, 1);
    expect(bloc.state.items, isEmpty);
    expect(bloc.state.status, DataStatus.success);
    expect(bloc.state.itemCount, 0);
  });

  test('addCatalogItem creates a cart item then increments quantity', () async {
    when(() => createCart.call(any())).thenReturn(TaskEither.right(cart));
    when(() => createCartItem.call(any())).thenReturn(TaskEither.right(cartItem));
    when(() => updateCartItem.call(any())).thenAnswer((invocation) {
      final entity = invocation.positionalArguments.first as CartItemEntity;
      return TaskEither.right(
        CartItemEntity(
          id: entity.id,
          cartId: entity.cartId,
          catalogItemId: entity.catalogItemId,
          quantity: entity.quantity,
          createdAt: entity.createdAt,
          updatedAt: entity.updatedAt,
          deletedAt: entity.deletedAt,
        ),
      );
    });

    bloc.add(const CartEvent.startCart());
    await pumpEventQueue();
    bloc.add(const CartEvent.addCatalogItem(catalogItemId: 3));
    await pumpEventQueue();
    bloc.add(const CartEvent.addCatalogItem(catalogItemId: 3));
    await pumpEventQueue();

    expect(bloc.state.items, hasLength(1));
    expect(bloc.state.items.first.quantity, 2);
    expect(bloc.state.itemCount, 2);
    verify(() => createCartItem.call(any())).called(1);
    verify(() => updateCartItem.call(any())).called(1);
  });

  test('decrement to zero keeps the item until prepareCheckout', () async {
    when(() => createCart.call(any())).thenReturn(TaskEither.right(cart));
    when(() => createCartItem.call(any())).thenReturn(TaskEither.right(cartItem));
    when(() => updateCartItem.call(any())).thenAnswer((invocation) {
      final entity = invocation.positionalArguments.first as CartItemEntity;
      return TaskEither.right(
        CartItemEntity(
          id: entity.id,
          cartId: entity.cartId,
          catalogItemId: entity.catalogItemId,
          quantity: entity.quantity,
          createdAt: entity.createdAt,
          updatedAt: entity.updatedAt,
          deletedAt: entity.deletedAt,
        ),
      );
    });

    bloc.add(const CartEvent.startCart());
    await pumpEventQueue();
    bloc.add(const CartEvent.addCatalogItem(catalogItemId: 3));
    await pumpEventQueue();
    bloc.add(const CartEvent.decrementCatalogItem(catalogItemId: 3));
    await pumpEventQueue();

    expect(bloc.state.items.first.quantity, 0);
    expect(bloc.state.items.first.deletedAt, isNull);
    expect(bloc.state.activeItems, isEmpty);
    expect(bloc.state.itemCount, 0);

    bloc.add(const CartEvent.prepareCheckout());
    await pumpEventQueue();

    expect(bloc.state.items.first.deletedAt, isNotNull);
    expect(bloc.state.checkoutPrepared, isTrue);
  });

  test('startCart emits error on failure', () async {
    final failure = CartFailure();
    when(() => createCart.call(any())).thenReturn(TaskEither.left(failure));

    bloc.add(const CartEvent.startCart());
    await pumpEventQueue();

    expect(bloc.state.status, DataStatus.error);
    expect(bloc.state.failure, isA<CartFailure>());
  });
}
