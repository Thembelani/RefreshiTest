import 'dart:convert';
import 'dart:math' as math;

const _catalogTimestamp = '2026-01-01T00:00:00.000Z';

class MockGraphqlStore {
  int _nextCartId = 1;
  int _nextCartItemId = 1;
  int _nextDeliveryId = 1;
  int _nextPaymentId = 1;

  void Function()? onPersist;

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
  final Map<String, Map<String, dynamic>> deliveries = {};
  final Map<String, Map<String, dynamic>> payments = {};
  final List<Map<String, dynamic>> deliveryTimes = _deliveryTimes();

  String _now() => DateTime.now().toUtc().toIso8601String();

  Map<String, dynamic> createCart() {
    final now = _now();
    final id = '${_nextCartId++}';
    final cart = {
      'id': id,
      'createdAt': now,
      'updatedAt': now,
      'placedAt': null,
      'deletedAt': null,
      '__typename': 'Cart',
    };
    carts[id] = cart;
    _save();
    return cart;
  }

  Map<String, dynamic>? getCart(String id) => carts[id];

  List<Map<String, dynamic>> getCarts() => carts.values.toList();

  Map<String, dynamic>? updateCart({required String id, String? placedAt}) {
    final cart = carts[id];
    if (cart == null) {
      return null;
    }
    cart['updatedAt'] = _now();
    cart['placedAt'] = placedAt;
    _save();
    return cart;
  }

  bool deleteCart(String id) {
    final cart = carts[id];
    if (cart == null) {
      return false;
    }
    cart['deletedAt'] = _now();
    cart['updatedAt'] = cart['deletedAt'];
    _save();
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
    _save();
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
    _save();
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
    _save();
    return true;
  }

  Map<String, dynamic> createDelivery({
    required String cartId,
    required String street,
    required String city,
    required String postalCode,
    String? deliveryTimeId,
  }) {
    final now = _now();
    final id = '${_nextDeliveryId++}';
    final delivery = {
      'id': id,
      'cartId': cartId,
      'street': street,
      'city': city,
      'postalCode': postalCode,
      'deliveryTimeId': deliveryTimeId,
      'createdAt': now,
      'updatedAt': now,
      'deletedAt': null,
      '__typename': 'Delivery',
    };
    deliveries[id] = delivery;
    _save();
    return delivery;
  }

  Map<String, dynamic>? getDelivery(String id) => deliveries[id];

  List<Map<String, dynamic>> getDeliveries() => deliveries.values.toList();

  Map<String, dynamic>? updateDelivery({
    required String id,
    required String street,
    required String city,
    required String postalCode,
    String? deliveryTimeId,
    String? deletedAt,
  }) {
    final delivery = deliveries[id];
    if (delivery == null) {
      return null;
    }
    delivery['street'] = street;
    delivery['city'] = city;
    delivery['postalCode'] = postalCode;
    delivery['deliveryTimeId'] = deliveryTimeId;
    delivery['updatedAt'] = _now();
    delivery['deletedAt'] = deletedAt;
    _save();
    return delivery;
  }

  bool deleteDelivery(String id) {
    final delivery = deliveries[id];
    if (delivery == null) {
      return false;
    }
    final now = _now();
    delivery['deletedAt'] = now;
    delivery['updatedAt'] = now;
    _save();
    return true;
  }

  Map<String, dynamic> createPayment({
    required String cartId,
    required String token,
  }) {
    final now = _now();
    final id = '${_nextPaymentId++}';
    final payment = {
      'id': id,
      'cartId': cartId,
      'token': token,
      'fulfilled': false,
      'createdAt': now,
      'updatedAt': now,
      'deletedAt': null,
      '__typename': 'Payment',
    };
    payments[id] = payment;
    _save();
    return payment;
  }

  Map<String, dynamic>? getPayment(String id) => payments[id];

  List<Map<String, dynamic>> getPayments() => payments.values.toList();

  Map<String, dynamic>? updatePayment({
    required String id,
    required String token,
    String? deletedAt,
    bool? fulfilled,
  }) {
    final payment = payments[id];
    if (payment == null) {
      return null;
    }
    payment['token'] = token;
    payment['updatedAt'] = _now();
    payment['deletedAt'] = deletedAt;
    if (payment['fulfilled'] == true || fulfilled == true) {
      payment['fulfilled'] = true;
    }
    _save();
    return payment;
  }

  bool deletePayment(String id) {
    final payment = payments[id];
    if (payment == null) {
      return false;
    }
    final now = _now();
    payment['deletedAt'] = now;
    payment['updatedAt'] = now;
    _save();
    return true;
  }

  List<Map<String, dynamic>> getDeliveryTimes() => deliveryTimes;

  Map<String, dynamic> toJson() => {
    'nextCartId': _nextCartId,
    'nextCartItemId': _nextCartItemId,
    'nextDeliveryId': _nextDeliveryId,
    'nextPaymentId': _nextPaymentId,
    'carts': carts,
    'cartItems': cartItems,
    'deliveries': deliveries,
    'payments': payments,
  };

  void hydrate(String? encoded) {
    if (encoded == null || encoded.isEmpty) {
      return;
    }
    final decoded = jsonDecode(encoded);
    if (decoded is! Map) {
      return;
    }
    _nextCartId = _asInt(decoded['nextCartId']) ?? _nextCartId;
    _nextCartItemId = _asInt(decoded['nextCartItemId']) ?? _nextCartItemId;
    _nextDeliveryId = _asInt(decoded['nextDeliveryId']) ?? _nextDeliveryId;
    _nextPaymentId = _asInt(decoded['nextPaymentId']) ?? _nextPaymentId;
    carts
      ..clear()
      ..addAll(_asRecordMap(decoded['carts']));
    cartItems
      ..clear()
      ..addAll(_asRecordMap(decoded['cartItems']));
    deliveries
      ..clear()
      ..addAll(_asRecordMap(decoded['deliveries']));
    payments
      ..clear()
      ..addAll(_asRecordMap(decoded['payments']));
    _ensureNextIds();
  }

  void _save() => onPersist?.call();

  void _ensureNextIds() {
    _nextCartId = math.max(_nextCartId, _maxId(carts) + 1);
    _nextCartItemId = math.max(_nextCartItemId, _maxId(cartItems) + 1);
    _nextDeliveryId = math.max(_nextDeliveryId, _maxId(deliveries) + 1);
    _nextPaymentId = math.max(_nextPaymentId, _maxId(payments) + 1);
  }
}

int? _asInt(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return null;
}

Map<String, Map<String, dynamic>> _asRecordMap(Object? value) {
  if (value is! Map) {
    return {};
  }
  return value.map((key, record) {
    return MapEntry(
      key.toString(),
      record is Map ? Map<String, dynamic>.from(record) : <String, dynamic>{},
    );
  });
}

int _maxId(Map<String, Map<String, dynamic>> records) {
  var maxId = 0;
  for (final id in records.keys) {
    final parsed = int.tryParse(id);
    if (parsed != null && parsed > maxId) {
      maxId = parsed;
    }
  }
  return maxId;
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

const _windowHours = <int>[9, 12, 15, 18];

String _formatHour(int hour) {
  final period = hour < 12 ? 'am' : 'pm';
  final display = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  return '$display:00 $period';
}

List<Map<String, dynamic>> _deliveryTimes() {
  final times = <Map<String, dynamic>>[];
  var id = 1;
  for (var day = 1; day <= 5; day++) {
    for (final hour in _windowHours) {
      times.add({
        'id': '$id',
        'day': '$day Dec',
        'time': _formatHour(hour),
        'createdAt': _catalogTimestamp,
        'updatedAt': _catalogTimestamp,
        'deletedAt': null,
        '__typename': 'DeliveryTime',
      });
      id++;
    }
  }
  return times;
}
