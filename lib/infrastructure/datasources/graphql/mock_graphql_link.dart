import 'package:gql/ast.dart';
import 'package:graphql/client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/mock_graphql_store.dart';

Link mockGraphqlLink(MockGraphqlStore store) {
  return Link.function((request, [forward]) {
    final definition = _operationDefinition(request);
    final name = request.operation.operationName ?? definition?.name?.value;
    final isMutation = definition?.type == OperationType.mutation;
    final variables = request.variables;

    return Stream.value(
      Response(
        response: const {},
        data: {
          '__typename': isMutation ? 'Mutation' : 'Query',
          ..._dataFor(store, name, variables),
        },
      ),
    );
  });
}

OperationDefinitionNode? _operationDefinition(Request request) {
  for (final definition in request.operation.document.definitions) {
    if (definition is OperationDefinitionNode) {
      return definition;
    }
  }
  return null;
}

Map<String, dynamic> _dataFor(
  MockGraphqlStore store,
  String? name,
  Map<String, dynamic> variables,
) {
  switch (name) {
    case 'GetCatalogItems':
      return {'getCatalogItems': store.catalogItems};
    case 'CreateCart':
      return {'createCart': store.createCart()};
    case 'GetCart':
      return {'getCart': store.getCart(variables['id'] as String)};
    case 'GetCarts':
      return {'getCarts': store.getCarts()};
    case 'UpdateCart':
      return {
        'updateCart': store.updateCart(
          id: variables['id'] as String,
          placedAt: variables['placedAt'] as String?,
        ),
      };
    case 'DeleteCart':
      return {'deleteCart': store.deleteCart(variables['id'] as String)};
    case 'CreateCartItem':
      return {
        'createCartItem': store.createCartItem(
          cartId: variables['cartId'] as String,
          catalogItemId: variables['catalogItemId'] as String,
          quantity: variables['quantity'] as int,
        ),
      };
    case 'GetCartItem':
      return {'getCartItem': store.getCartItem(variables['id'] as String)};
    case 'GetCartItems':
      return {'getCartItems': store.getCartItems()};
    case 'UpdateCartItem':
      return {
        'updateCartItem': store.updateCartItem(
          id: variables['id'] as String,
          quantity: variables['quantity'] as int,
          deletedAt: variables['deletedAt'] as String?,
        ),
      };
    case 'DeleteCartItem':
      return {
        'deleteCartItem': store.deleteCartItem(variables['id'] as String),
      };
    case 'CreateDelivery':
      return {
        'createDelivery': store.createDelivery(
          cartId: variables['cartId'] as String,
          street: variables['street'] as String,
          city: variables['city'] as String,
          postalCode: variables['postalCode'] as String,
          deliveryTimeId: variables['deliveryTimeId'] as String?,
        ),
      };
    case 'GetDelivery':
      return {'getDelivery': store.getDelivery(variables['id'] as String)};
    case 'GetDeliveries':
      return {'getDeliveries': store.getDeliveries()};
    case 'UpdateDelivery':
      return {
        'updateDelivery': store.updateDelivery(
          id: variables['id'] as String,
          street: variables['street'] as String,
          city: variables['city'] as String,
          postalCode: variables['postalCode'] as String,
          deliveryTimeId: variables['deliveryTimeId'] as String?,
          deletedAt: variables['deletedAt'] as String?,
        ),
      };
    case 'DeleteDelivery':
      return {
        'deleteDelivery': store.deleteDelivery(variables['id'] as String),
      };
    case 'CreatePayment':
      return {
        'createPayment': store.createPayment(
          cartId: variables['cartId'] as String,
          token: variables['token'] as String,
        ),
      };
    case 'GetPayment':
      return {'getPayment': store.getPayment(variables['id'] as String)};
    case 'GetPayments':
      return {'getPayments': store.getPayments()};
    case 'UpdatePayment':
      return {
        'updatePayment': store.updatePayment(
          id: variables['id'] as String,
          token: variables['token'] as String,
          deletedAt: variables['deletedAt'] as String?,
        ),
      };
    case 'DeletePayment':
      return {
        'deletePayment': store.deletePayment(variables['id'] as String),
      };
    case 'GetDeliveryTimes':
      return {'getDeliveryTimes': store.getDeliveryTimes()};
    default:
      return {'getCatalogItems': store.catalogItems};
  }
}
