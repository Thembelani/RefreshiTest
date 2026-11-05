import 'package:mocktail/mocktail.dart';
import 'package:refreshi_test/application/use_cases/cart/create_cart_use_case.dart';
import 'package:refreshi_test/application/use_cases/cart_item/create_cart_item_use_case.dart';
import 'package:refreshi_test/application/use_cases/cart_item/update_cart_item_use_case.dart';
import 'package:refreshi_test/application/use_cases/catalog_item/get_catalog_items_use_case.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/clients/cart_graph_client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/clients/cart_item_graph_client.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/clients/catalog_item_graph_client.dart';

class MockGetCatalogItemsUseCase extends Mock
    implements GetCatalogItemsUseCase {}

class MockCatalogItemGraphClient extends Mock
    implements CatalogItemGraphClient {}

class MockCreateCartUseCase extends Mock implements CreateCartUseCase {}

class MockCreateCartItemUseCase extends Mock implements CreateCartItemUseCase {}

class MockUpdateCartItemUseCase extends Mock implements UpdateCartItemUseCase {}

class MockCartGraphClient extends Mock implements CartGraphClient {}

class MockCartItemGraphClient extends Mock implements CartItemGraphClient {}
