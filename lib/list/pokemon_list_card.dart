import 'package:flutter/material.dart';

import '../__generated__/api.graphql.dart';

class PokemonListCard extends StatelessWidget {
  final PokemonListCardItemMixin itemFrag;
  const PokemonListCard({Key? key, required this.itemFrag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: itemFrag.image != null ? Image.network(itemFrag.image!) : null,
        title: Text(itemFrag.name ?? "<No Name>"),
      ),
    );
  }
}
