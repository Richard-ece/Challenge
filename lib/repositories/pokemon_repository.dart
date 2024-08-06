import 'package:pokedex/api/pokemon_api.dart';
import 'package:pokedex/models/pokemon/pokemon_complete_model.dart';
import 'package:pokedex/models/pokemon/pokemon_simple_list_model.dart';

class PokemonRepository {
  Future<PokemonSimpleList> getPokemonSimpleList(
      {required int pageIndex}) async {
    return PokemonApi().getPokemonSimpleList(pageIndex: pageIndex);
  }

  Future<PokemonComplete> getPokemonComplete({required int id}) async {
    return PokemonApi().getPokemonComplete(id: id);
  }
}
