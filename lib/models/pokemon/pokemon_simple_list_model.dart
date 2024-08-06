import 'package:pokedex/models/pokemon/pokemon_simple_model.dart';

class PokemonSimpleList {
  final List<PokemonSimple> pokemonSimpleList;
  final bool canLoadNexPage;

  PokemonSimpleList(
      {required this.pokemonSimpleList, required this.canLoadNexPage});

  factory PokemonSimpleList.fromJson(Map<String, dynamic> json) {
    final canLoadNextPage = json['next'] != null;
    final pokemonList = (json['results'] as List)
        .map((listingJson) => PokemonSimple.fromJson(listingJson))
        .toList();

    return PokemonSimpleList(
        pokemonSimpleList: pokemonList, canLoadNexPage: canLoadNextPage);
  }
}
