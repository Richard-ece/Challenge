abstract class PokemonEvent {}

class PokemonSimpleListResquest extends PokemonEvent {
  final int page;

  PokemonSimpleListResquest({required this.page});
}

class PokemonCompleteResquest extends PokemonEvent {
  final int id;

  PokemonCompleteResquest({required this.id});
}

class AddFavoritePokemon extends PokemonEvent {
  final int id;

  AddFavoritePokemon({required this.id});
}

class RemoveFavoritePokemon extends PokemonEvent {
  final int id;

  RemoveFavoritePokemon({required this.id});
}
