import 'package:flutter/material.dart';
import 'package:flutter_graphql_artemis_example/list/pokemon_list.dart';

class PokemonListScreen extends StatelessWidget {
  const PokemonListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Pokemon")),
      body: const PokemonList(),
    );
  }
}
