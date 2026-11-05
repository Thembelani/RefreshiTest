import 'package:graphql/client.dart';
import 'package:injectable/injectable.dart';
import 'package:refreshi_test/infrastructure/datasources/graphql/mock_graphql_link.dart';

@lazySingleton
class GraphqlClient {
  GraphqlClient()
      : client = GraphQLClient(
          cache: GraphQLCache(),
          link: mockGraphqlLink(),
        );
  final GraphQLClient client;
}