import 'package:pokedex/models/pokemon/pokemon_model.dart';

class PokemonSimple extends Pokemon {
  final String url;

  PokemonSimple({required this.url, required int id, required String name})
      : super(id: id, name: name);

  factory PokemonSimple.fromJson(Map<String, dynamic> json) {
    final url = json['url'];
    final id = int.parse(url.split('/')[6]);

    return PokemonSimple(id: id, name: json['name'], url: url);
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
}
