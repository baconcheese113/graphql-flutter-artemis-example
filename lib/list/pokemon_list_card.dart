import 'package:flutter/material.dart';
import 'package:flutter_graphql_artemis_example/detail/pokemon_detail_screen.dart';

import '../__generated__/api.graphql.dart';

class PokemonListCard extends StatelessWidget {
  final PokemonListCardItemMixin itemFrag;
  const PokemonListCard({Key? key, required this.itemFrag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void handleTap() {
      Navigator.pushNamed(
        context,
        PokemonDetailScreen.routeName,
        arguments: PokemonDetailScreenArgs(itemFrag.name!),
      );
    }

    return Card(
      child: ListTile(
        onTap: handleTap,
        leading: itemFrag.image != null ? Image.network(itemFrag.image!) : null,
        title: Text(itemFrag.name ?? "<No Name>"),
      ),
    );
  }
}
