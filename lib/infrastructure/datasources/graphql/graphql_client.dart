import 'dart:convert';

import 'package:graphql/client.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/mock_graphql_link.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/mock_graphql_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class GraphqlClient {
  GraphqlClient(this._prefs) : store = MockGraphqlStore() {
    store.hydrate(_prefs.getString(_storageKey));
    store.onPersist = _persist;
    client = GraphQLClient(cache: GraphQLCache(), link: mockGraphqlLink(store));
  }

  static const _storageKey = 'mockGraphqlStore';

  final SharedPreferences _prefs;
  final MockGraphqlStore store;
  late final GraphQLClient client;

  void _persist() {
    _prefs.setString(_storageKey, jsonEncode(store.toJson()));
  }
}
