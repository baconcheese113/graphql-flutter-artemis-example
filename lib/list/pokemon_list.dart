import 'package:flutter/material.dart';
import 'package:flutter_graphql_artemis_example/list/pokemon_list_card.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../__generated__/api.graphql.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: POKEMON_LIST_QUERY_DOCUMENT,
          // operationName is optional
          operationName: POKEMON_LIST_QUERY_DOCUMENT_OPERATION_NAME,
          // Unable to use cache with Artemis
          // see Reasons Not To Use Artemis about cache limitation
          // https://github.com/comigor/artemis/issues/350
          // https://github.com/zino-hofmann/graphql-flutter/blob/master/packages/graphql/README.md#policies
          fetchPolicy: FetchPolicy.noCache,
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.isLoading) return const CircularProgressIndicator();
          if (result.hasException) return Center(child: Text(result.exception!.toString()));

          print("result is $result");
          // result.data is missing all fragment data
          final data = PokemonList$Query.fromJson(result.data!);

          final cardList = data.pokemons!.results!.map((pokemon) {
            print("Pokemon name: ${pokemon!.name}");
            return PokemonListCard(itemFrag: pokemon);
          }).toList();

          return RefreshIndicator(
              child: ListView(children: cardList),
              onRefresh: () async {
                await refetch!();
              });
        });
  }
}
