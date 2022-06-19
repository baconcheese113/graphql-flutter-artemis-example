# Flutter Graphql Artemis Example

Simple Flutter example project using [graphql-flutter](https://github.com/zino-hofmann/graphql-flutter) and [artemis](https://github.com/comigor/artemis) with a focus on folder/file structure.

Uses the PokeApi schema available here https://graphql-pokeapi.graphcdn.app/

## Goal

This project aims to replicate a typical client structure using npm packages Apollo or Relay.js. and act as a point of reference. In general, queries and fragments should live as close as possible to the widgets that use them and should not be reused across multiple widgets. 

---

## Reasons not to use Artemis

- As of now, Artemis doesn't support parsing out graphql queries from `.dart` files, so each query needs to be separated into it's own `.graphql` file. This is suboptimal because it adds a level of separation between the code and the query definition, and can make refactoring more difficult.

---

## Schema Generation (introspection)
1) The schema is included in this project, but you can regenerate it with the [GraphQL Android Studio plugin](https://plugins.jetbrains.com/plugin/8097-graphql). You can add it in Android Studio from `File->Preferences->Plugins` and then searching for `GraphQL` in the Marketplace. It uses the [.graphqlconfig](\.graphqlconfig) configuration file.

2) Next, expand the plugin from the bottom of the window and double click on `Endpoints->Default GraphQL Endpoint` and select `Get GraphQL Schema From Endpoint`
3) You should be able to see your schema in [graphql/schema.dart](graphql/schema.dart)

---

## Building the Types
Once you have the schema, you're ready to generate the type files using Build Runner. In the terminal use the command:
```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```
This also deletes the old generated types if they exist. You should now be able to see the Artemis types in [lib/\_\_generated\_\_](lib)

---

## Using Queries

Here's an example using a Query Widget with the .graphql queries and Artemis types.

> Make sure to use the `.query.graphql` and `.fragment.graphql` filename postfixes

[pokemon_list.query.graphql](lib/list/pokemon_list.query.graphql)
```graphql
query PokemonList {
    pokemons(limit: 50) {
        count
        results {
            # id is required to use this field with cache
            id
            ...pokemonListCard_item
        }
    }
}
```
[pokemon_list.dart#L12](lib/list/pokemon_list.dart#L12)
```dart
return Query(
    options: QueryOptions(
        document: POKEMON_LIST_QUERY_DOCUMENT,
        // operationName is optional
        operationName: POKEMON_LIST_QUERY_DOCUMENT_OPERATION_NAME,
    ),
    builder: (QueryResult result, {fetchMore, refetch}) {
        if (result.isLoading) return const CircularProgressIndicator();
        if (result.hasException) return Center(child: Text(result.exception!.toString()));

        final data = PokemonList$Query.fromJson(result.data!);

        final cardList = data.pokemons!.results!.map((pokemon) {
        print("Pokemon name: ${pokemon!.name}");
        return PokemonListCard(itemFrag: pokemon);
        }).toList();

        ...
    });
```

---

## Using Fragments

> This fragment is used with the query from the above section

[pokemon_list_card.fragment.graphql](lib/list/pokemon_list_card.fragment.graphql)
```graphql
fragment pokemonListCard_item on PokemonItem {
    # __typename and id are required to use fragment with cache
    __typename
    id
    url
    name
    image
    artwork
}
```
[pokemon_list_card.dart](lib/list/pokemon_list_card.dart)
```dart
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
```

---
## Using Artemis Helper Classes

If you pass `true` to generate_helpers in [build.yaml](./build.yaml) Artemis will generate a class for each query/mutation similar to the following
```dart
// ***** This code is generated in api.graphql.dart ****** 
class PokemonDetailScreenQuery extends GraphQLQuery<PokemonDetailScreen$Query,
    PokemonDetailScreenArguments> {
  PokemonDetailScreenQuery({required this.variables});

  @override
  final DocumentNode document = POKEMON_DETAIL_SCREEN_QUERY_DOCUMENT;

  @override
  final String operationName =
      POKEMON_DETAIL_SCREEN_QUERY_DOCUMENT_OPERATION_NAME;

  @override
  final PokemonDetailScreenArguments variables;

  @override
  List<Object?> get props => [document, operationName, variables];
  @override
  PokemonDetailScreen$Query parse(Map<String, dynamic> json) =>
      PokemonDetailScreen$Query.fromJson(json);
}
```
You can then use the helper class to configure the query and parse the result
```dart
// We can set query as a variable here just to decrease bloat
final query = PokemonDetailScreenQuery(
  variables: PokemonDetailScreenArguments(name: args.name),
);
return Query(
  options: QueryOptions(
    document: query.document,
    variables: query.variables.toJson(),
  ),
  builder: (result, {fetchMore, refetch}) {
    if (result.isLoading) return const CircularProgressIndicator();
    if (result.hasException) return Text(result.exception.toString());

    final data = query.parse(result.data!);
    final pokemon = data.pokemon!;

    return Column(
      children: [
        Image.network(data.pokemon.sprites!.backDefault!),
        Center(child: Text(args.name, style: const TextStyle(fontSize: 24)))
      ],
    );
  }),
);
```

## Other Tips

### Editing build.yaml
Artemis uses [Build_Runner](https://github.com/dart-lang/build/tree/master/build_runner#readme) to generate Dart files. Build_Runner uses a `build.yaml` configuration file and Artemis (being a builder) is listed under `builders` and has it's own list of [configuration options](https://github.com/comigor/artemis#configuration). You'll receive this error 
> Schema validation: Property 'targets' is not allowed

until you configure a JSONSchema in Android Studio for the Dart Build System to understand `build.yaml`. Just follow the directions [here](https://stackoverflow.com/a/70408631/1363772) to resolve it.

