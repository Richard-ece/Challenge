import 'package:dio/dio.dart';
import 'package:pokedex/models/pokemon/pokemon_complete_model.dart';
import 'package:pokedex/models/pokemon/pokemon_simple_list_model.dart';

class PokemonApi {
  final baseUrl = 'https://pokeapi.co';

  Future<PokemonSimpleList> getPokemonSimpleList(
      {required int pageIndex}) async {
    return Dio().get("$baseUrl/api/v2/pokemon", queryParameters: {
      'limit': '300',
      'offset': (pageIndex * 200).toString()
    }).then((response) {
      return PokemonSimpleList.fromJson(response.data!);
    });
  }

  Future<PokemonComplete> getPokemonComplete({required int id}) async {
    return Dio().get("$baseUrl/api/v2/pokemon/$id").then((response) {
      return PokemonComplete.fromJson(response.data!);
    });
  }
}
