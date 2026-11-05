import 'package:graphql/client.dart';

Link mockGraphqlLink() {
  return Link.function((request, [forward]) {
    return Stream.value(
      Response(
        response: const {},
        data: const {
          '__typename': 'Query',
          'getCatalogItems': _catalogItems,
        },
      ),
    );
  });
}

const _catalogItems = [
  {
    'id': '1',
    'name': 'Berry Latte',
    'sellingPrice': 45.5,
    '__typename': 'CatalogItem',
  },
  {
    'id': '2',
    'name': 'River Cream',
    'sellingPrice': 32.0,
    '__typename': 'CatalogItem',
  },
  {
    'id': '3',
    'name': 'Spice Bite',
    'sellingPrice': 18.0,
    '__typename': 'CatalogItem',
  },
  {
    'id': '4',
    'name': 'Frost Soda',
    'sellingPrice': 22.0,
    '__typename': 'CatalogItem',
  },
  {
    'id': '5',
    'name': 'Golden Brew',
    'sellingPrice': 38.5,
    '__typename': 'CatalogItem',
  },
  {
    'id': '6',
    'name': 'Spice Tart',
    'sellingPrice': 16.0,
    '__typename': 'CatalogItem',
  },
  {
    'id': '7',
    'name': 'Ginger Slice',
    'sellingPrice': 19.5,
    '__typename': 'CatalogItem',
  },
  {
    'id': '8',
    'name': 'Velvet Malt',
    'sellingPrice': 41.0,
    '__typename': 'CatalogItem',
  },
  {
    'id': '9',
    'name': 'Orchard Tart',
    'sellingPrice': 24.5,
    '__typename': 'CatalogItem',
  },
  {
    'id': '10',
    'name': 'Ruby Roast',
    'sellingPrice': 36.0,
    '__typename': 'CatalogItem',
  },
  {
    'id': '11',
    'name': 'Cedar Pod',
    'sellingPrice': 28.0,
    '__typename': 'CatalogItem',
  },
  {
    'id': '12',
    'name': 'River Roast',
    'sellingPrice': 33.5,
    '__typename': 'CatalogItem',
  },
  {
    'id': '13',
    'name': 'Copper Draught',
    'sellingPrice': 29.0,
    '__typename': 'CatalogItem',
  },
];
