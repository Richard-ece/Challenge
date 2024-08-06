import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pokedex/bloc/pokemon/pokemon_bloc.dart';
import 'package:pokedex/bloc/pokemon/pokemon_event.dart';
import 'package:pokedex/bloc/pokemon/pokemon_state.dart';
import 'package:pokedex/models/pokemon/pokemon_complete_model.dart';
import 'package:pokedex/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/pages/widget/theme.dart';

class DescriptionPokemonPage extends HookWidget {
  const DescriptionPokemonPage({Key? key, required this.pokemonId})
      : super(key: key);

  final int pokemonId;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    useEffect(() {
      context.read<PokemonBloc>().add(PokemonCompleteResquest(id: pokemonId));
      return null;
    });

    return Scaffold(
      backgroundColor: themeNotifier.isDarkMode ? Colors.grey[900] : Colors.redAccent, 
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state.pokemonCompleteStatus == RequestStatus.loadInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.pokemonCompleteStatus == RequestStatus.loadSuccess) {
            var typesPokemon =
                state.pokemonComplete!.types.map((type) => type.type.name);
            return Stack(
              alignment: Alignment.center,
              children: [
                const Positioned(
                  top: 20,
                  left: 10,
                  child: BackButton(),
                ),
                Positioned(
                  top: 70,
                  left: 20,
                  right: 20,
                  child: NamePokemon(name: state.pokemonComplete!.name),
                ),
                Positioned(
                  top: 110,
                  left: 22,
                  child: TypesPokemon(typesPokemon: typesPokemon),
                ),
                Positioned(
                  top: 20,
                  right: 30,
                  child: StarFavoritePokemon(
                    favoritePokemons: state.favoritePokemons!,
                    pokemon: state.pokemonComplete!,
                  ),
                ),
                Positioned(
                  top: height * 0.18,
                  right: -30,
                  child: const ImagePokeballBackground(),
                ),
                Positioned(
                  bottom: 0,
                  child: InfoPokemon(
                    weightPokemon: state.pokemonComplete!.weight,
                    heightPokemon: state.pokemonComplete!.height,
                  ),
                ),
                Positioned(
                  top: (height * 0.2),
                  left: (width / 2) - 100,
                  child: Hero(
                    tag: 1,
                    child: ImagePokemon(
                      imageUrlPokemon:
                          state.pokemonComplete!.sprite.frontDefault,
                    ),
                  ),
                )
              ],
            );
          } else if (state.pokemonCompleteStatus == RequestStatus.loadFailed) {
            return Center(
              child: Text(state.errorPokemonSimpleList.toString()),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class StarFavoritePokemon extends StatelessWidget {
  const StarFavoritePokemon({
    Key? key,
    required this.favoritePokemons,
    required this.pokemon,
  }) : super(key: key);

  final List<int> favoritePokemons;
  final PokemonComplete pokemon;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return GestureDetector(
      onTap: () {
        if (favoritePokemons.contains(pokemon.id)) {
          context
              .read<PokemonBloc>()
              .add(RemoveFavoritePokemon(id: pokemon.id));
        } else {
          context.read<PokemonBloc>().add(AddFavoritePokemon(id: pokemon.id));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(
          favoritePokemons.contains(pokemon.id)
              ? const IconData(0xecf3, fontFamily: 'MaterialIcons')
              : const IconData(0xecf2, fontFamily: 'MaterialIcons'),
          color: themeNotifier.isDarkMode ? Colors.yellow : Colors.white, 
          size: 40.0,
        ),
      ),
    );
  }
}


class ImagePokemon extends StatelessWidget {
  const ImagePokemon({
    Key? key,
    required this.imageUrlPokemon,
  }) : super(key: key);

  final String imageUrlPokemon;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: 200,
      width: 200,
      imageUrl: imageUrlPokemon,
      fit: BoxFit.cover,
    );
  }
}

class InfoPokemon extends StatelessWidget {
  const InfoPokemon({
    Key? key,
    required this.weightPokemon,
    required this.heightPokemon,
  }) : super(key: key);

  final int weightPokemon;
  final int heightPokemon;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Container(
      width: width,
      height: height * 0.6,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: themeNotifier.isDarkMode ? Colors.grey[850] : Colors.white), 
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            RowDescription(
              textLeft: 'Height',
              textRigth: (heightPokemon / 10).toString() + " m",
            ),
            RowDescription(
              textLeft: 'Weight',
              textRigth: (weightPokemon / 10).toString() + " kg",
            ),
          ],
        ),
      ),
    );
  }
}

class ImagePokeballBackground extends StatelessWidget {
  const ImagePokeballBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/pokeball.png',
      height: 200,
      fit: BoxFit.fitHeight,
    );
  }
}

class TypesPokemon extends StatelessWidget {
  const TypesPokemon({
    Key? key,
    required this.typesPokemon,
  }) : super(key: key);

  final Iterable<String> typesPokemon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          typesPokemon.join(", "),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white), 
          textAlign: TextAlign.left,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }
}

class NamePokemon extends StatelessWidget {
  const NamePokemon({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () {
          Navigator.pop(context);
        });
  }
}

class RowDescription extends StatelessWidget {
  const RowDescription(
      {Key? key, required this.textLeft, required this.textRigth})
      : super(key: key);

  final String textLeft;
  final String textRigth;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: width * 0.3,
            child: Text(
              textLeft,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ), 
            ),
          ),
          Text(
            textRigth,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ), 
          ),
        ],
      ),
    );
  }
}
