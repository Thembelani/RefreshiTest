const _catalogTimestamp = '2026-01-01T00:00:00.000Z';

class MockGraphqlStore {
  int _nextCartId = 1;
  int _nextCartItemId = 1;

  final List<Map<String, dynamic>> catalogItems = [
    _catalogItem(id: '1', name: 'Berry Latte', sellingPrice: 45.5),
    _catalogItem(id: '2', name: 'River Cream', sellingPrice: 32.0),
    _catalogItem(id: '3', name: 'Spice Bite', sellingPrice: 18.0),
    _catalogItem(id: '4', name: 'Frost Soda', sellingPrice: 22.0),
    _catalogItem(id: '5', name: 'Golden Brew', sellingPrice: 38.5),
    _catalogItem(id: '6', name: 'Spice Tart', sellingPrice: 16.0),
    _catalogItem(id: '7', name: 'Ginger Slice', sellingPrice: 19.5),
    _catalogItem(id: '8', name: 'Velvet Malt', sellingPrice: 41.0),
    _catalogItem(id: '9', name: 'Orchard Tart', sellingPrice: 24.5),
    _catalogItem(id: '10', name: 'Ruby Roast', sellingPrice: 36.0),
    _catalogItem(id: '11', name: 'Cedar Pod', sellingPrice: 28.0),
    _catalogItem(id: '12', name: 'River Roast', sellingPrice: 33.5),
    _catalogItem(id: '13', name: 'Copper Draught', sellingPrice: 29.0),
  ];

  final Map<String, Map<String, dynamic>> carts = {};
  final Map<String, Map<String, dynamic>> cartItems = {};

  String _now() => DateTime.now().toUtc().toIso8601String();

  Map<String, dynamic> createCart() {
    final now = _now();
    final id = '${_nextCartId++}';
    final cart = {
      'id': id,
      'createdAt': now,
      'updatedAt': now,
      'deletedAt': null,
      '__typename': 'Cart',
    };
    carts[id] = cart;
    return cart;
  }

  Map<String, dynamic>? getCart(String id) => carts[id];

  List<Map<String, dynamic>> getCarts() => carts.values.toList();

  Map<String, dynamic>? updateCart(String id) {
    final cart = carts[id];
    if (cart == null) {
      return null;
    }
    cart['updatedAt'] = _now();
    return cart;
  }

  bool deleteCart(String id) {
    final cart = carts[id];
    if (cart == null) {
      return false;
    }
    cart['deletedAt'] = _now();
    cart['updatedAt'] = cart['deletedAt'];
    return true;
  }

  Map<String, dynamic> createCartItem({
    required String cartId,
    required String catalogItemId,
    required int quantity,
  }) {
    final now = _now();
    final id = '${_nextCartItemId++}';
    final item = {
      'id': id,
      'cartId': cartId,
      'catalogItemId': catalogItemId,
      'quantity': quantity,
      'createdAt': now,
      'updatedAt': now,
      'deletedAt': null,
      '__typename': 'CartItem',
    };
    cartItems[id] = item;
    return item;
  }

  Map<String, dynamic>? getCartItem(String id) => cartItems[id];

  List<Map<String, dynamic>> getCartItems() => cartItems.values.toList();

  Map<String, dynamic>? updateCartItem({
    required String id,
    required int quantity,
    String? deletedAt,
  }) {
    final item = cartItems[id];
    if (item == null) {
      return null;
    }
    item['quantity'] = quantity;
    item['updatedAt'] = _now();
    item['deletedAt'] = deletedAt;
    return item;
  }

  bool deleteCartItem(String id) {
    final item = cartItems[id];
    if (item == null) {
      return false;
    }
    final now = _now();
    item['deletedAt'] = now;
    item['updatedAt'] = now;
    return true;
  }
}

Map<String, dynamic> _catalogItem({
  required String id,
  required String name,
  required double sellingPrice,
}) {
  return {
    'id': id,
    'name': name,
    'sellingPrice': sellingPrice,
    'createdAt': _catalogTimestamp,
    'updatedAt': _catalogTimestamp,
    'deletedAt': null,
    '__typename': 'CatalogItem',
  };
}
