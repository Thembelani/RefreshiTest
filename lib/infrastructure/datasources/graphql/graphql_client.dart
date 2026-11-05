import 'package:graphql/client.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/mock_graphql_link.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/mock_graphql_store.dart';

@lazySingleton
class GraphqlClient {
  GraphqlClient() : store = MockGraphqlStore() {
    client = GraphQLClient(
      cache: GraphQLCache(),
      link: mockGraphqlLink(store),
    );
  }

  final MockGraphqlStore store;
  late final GraphQLClient client;
}
