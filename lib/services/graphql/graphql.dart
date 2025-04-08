import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:ferry/ferry.dart';
import 'package:my_todo/locator.dart';
import 'package:my_todo/services/token/token_service.dart';

Client initClient(String uri) {
  final tokenService = locator<TokenService>();

  final graphql.HttpLink httpLink = graphql.HttpLink(uri);

  // WebSocket link for subscriptions
  final graphql.WebSocketLink webSocketLink = graphql.WebSocketLink(
    uri.replaceFirst('https://', 'wss://'),
    // Replace with your GraphQL WebSocket endpoint
    config: graphql.SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: const Duration(seconds: 30),
      queryAndMutationTimeout: const Duration(seconds: 30),
      initialPayload: () async {
        final token = tokenService.removeAuth ? null : tokenService.token;
        if (tokenService.removeAuth) {
          tokenService.updateRemoveAuth(false);
        }
        return {
          'headers': {'Authorization': token != null ? 'Bearer $token' : null},
        };
      },
    ),
  );

  // Auth link to manage auth for HTTP link
  final graphql.AuthLink authLink = graphql.AuthLink(
    getToken: () async {
      final removeAuth = tokenService.removeAuth;
      if (removeAuth) {
        tokenService.updateRemoveAuth(false);
        return null;
      }
      return tokenService.token != null ? 'Bearer ${tokenService.token}' : null;
    },
  );

  // Use SplitLink to use the WebSocket link for subscriptions and HTTP link for queries and mutations
  final Link link = Link.split(
    (request) => request.isSubscription,
    webSocketLink,
    authLink.concat(httpLink),
  );

  final cache = Cache();
  final defaultFetchPolicies = {
    OperationType.query: FetchPolicy.NoCache,
    OperationType.mutation: FetchPolicy.NoCache,
    OperationType.subscription: FetchPolicy.NoCache
  };

  final client = Client(
    link: link,
    cache: cache,
    defaultFetchPolicies: defaultFetchPolicies,
  );

  return client;
}
