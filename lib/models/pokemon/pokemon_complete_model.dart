import 'package:pokedex/models/pokemon/pokemon_model.dart';

class PokemonComplete extends Pokemon {
  final List<Abilities> abilities;
  final List<Types> types;
  final int height;
  final int weight;
  final Sprite sprite;

  PokemonComplete({
    required this.abilities,
    required this.types,
    required this.height,
    required this.weight,
    required this.sprite,
    required int id,
    required String name,
  }) : super(id: id, name: name);

  factory PokemonComplete.fromJson(Map<String, dynamic> json) {
    return PokemonComplete(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      sprite: Sprite.fromJson(json['sprites']),
      abilities: _listFromJsonAbilities(json["abilities"]),
      types: _listFromJsonTypes(json["types"]),
    );
  }

  static List<Abilities> _listFromJsonAbilities(dynamic json) {
    final List<Abilities> items = [];
    json.forEach((x) => items.add(Abilities.fromJson(x)));
    return items;
  }

  static List<Types> _listFromJsonTypes(dynamic json) {
    final List<Types> items = [];
    json.forEach((x) => items.add(Types.fromJson(x)));
    return items;
  }
}

class Sprite {
  final String frontDefault;

  Sprite({required this.frontDefault});

  factory Sprite.fromJson(Map<String, dynamic> json) {
    return Sprite(
      frontDefault: json['front_default'],
    );
  }
}

class Abilities {
  final Ability ability;

  Abilities({required this.ability});

  factory Abilities.fromJson(Map<String, dynamic> json) {
    return Abilities(
      ability: Ability.fromJson(json['ability']),
    );
  }
}

class Ability {
  final String name;

  Ability({required this.name});

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      name: json['name'],
    );
  }
}

class Types {
  final Type type;

  Types({required this.type});

  factory Types.fromJson(Map<String, dynamic> json) {
    return Types(
      type: Type.fromJson(json['type']),
    );
  }
}

class Type {
  final String name;

  Type({required this.name});

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      name: json['name'],
    );
  }
}
