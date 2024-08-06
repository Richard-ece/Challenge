import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/bloc/pokemon/pokemon_event.dart';
import 'package:pokedex/bloc/pokemon/pokemon_state.dart';
import 'package:pokedex/repositories/pokemon_repository.dart';
import 'package:pokedex/utils/constants.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final _pokemonRespository = PokemonRepository();

  PokemonBloc() : super(const PokemonState()) {
    on<PokemonSimpleListResquest>((event, emit) async {
      emit(state.copyWith(
          pokemonSimpleListStatus: RequestStatus.loadInProgress));
      await _pokemonRespository
          .getPokemonSimpleList(pageIndex: event.page)
          .then((pokemonSimpleListResponse) {
        emit(
          state.copyWith(
              pokemonSimpleList: pokemonSimpleListResponse.pokemonSimpleList,
              canLoadNextPage: pokemonSimpleListResponse.canLoadNexPage,
              pokemonSimpleListStatus: RequestStatus.loadSuccess),
        );
      }).catchError((e) {
        emit(state.copyWith(
          errorPokemonSimpleList: e,
          pokemonSimpleListStatus: RequestStatus.loadFailed,
        ));
      });
    });

    on<PokemonCompleteResquest>((event, emit) async {
      emit(state.copyWith(pokemonCompleteStatus: RequestStatus.loadInProgress));
      await _pokemonRespository
          .getPokemonComplete(id: event.id)
          .then((pokemonCompleteResponse) {
        emit(
          state.copyWith(
              pokemonComplete: pokemonCompleteResponse,
              pokemonCompleteStatus: RequestStatus.loadSuccess),
        );
      }).catchError((e) {
        emit(state.copyWith(
          errorPokemonComplete: e,
          pokemonCompleteStatus: RequestStatus.loadFailed,
        ));
      });
    });

    on<AddFavoritePokemon>((event, emit) async {
      emit(state
          .copyWith(favoritePokemons: [...?state.favoritePokemons, event.id]));
    });

    on<RemoveFavoritePokemon>((event, emit) async {
      var array = [...?state.favoritePokemons];
      array.remove(event.id);
      emit(state.copyWith(favoritePokemons: array));
    });
  }
}
