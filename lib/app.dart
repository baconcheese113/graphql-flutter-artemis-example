import 'package:flutter/material.dart';
import 'package:flutter_graphql_artemis_example/detail/pokemon_detail_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'list/pokemon_list_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ValueNotifier(GraphQLClient(
        cache: GraphQLCache(store: HiveStore()),
        link: HttpLink("https://graphql-pokeapi.graphcdn.app"),
      )),
      child: MaterialApp(
        title: "Pokemon Demo",
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/pokemon':
              return MaterialPageRoute(settings: settings, builder: (_) => const PokemonDetailScreen());
              break;
            case '/':
            default:
              return MaterialPageRoute(builder: (_) => const PokemonListScreen());
          }
        },
      ),
    );
  }
}
