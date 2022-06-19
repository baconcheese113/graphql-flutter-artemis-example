import 'package:flutter/material.dart';
import 'package:flutter_graphql_artemis_example/__generated__/api.graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PokemonDetailScreenArgs {
  final String name;
  PokemonDetailScreenArgs(this.name);
}

class PokemonDetailScreen extends StatelessWidget {
  const PokemonDetailScreen({Key? key}) : super(key: key);

  static String routeName = '/pokemon';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PokemonDetailScreenArgs;

    return Scaffold(
      appBar: AppBar(title: Text(args.name)),
      body: Center(
        child: Query(
            options: QueryOptions(
              document: POKEMON_DETAIL_SCREEN_QUERY_DOCUMENT,
              variables: PokemonDetailScreenArguments(name: args.name).toJson(),
            ),
            builder: (result, {fetchMore, refetch}) {
              if (result.isLoading) return const CircularProgressIndicator();
              if (result.hasException) return Text(result.exception.toString());

              final data = PokemonDetailScreen$Query.fromJson(result.data!);
              final pokemon = data.pokemon;
              if (pokemon == null) Navigator.pop(context);

              return Column(
                children: [
                  Image.network(data.pokemon!.sprites!.backDefault!),
                  Center(child: Text(args.name, style: const TextStyle(fontSize: 24)))
                ],
              );
            }),
      ),
    );
  }
}
