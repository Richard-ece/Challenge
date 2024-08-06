import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pokedex/pages/widget/theme.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/bloc/pokemon/pokemon_bloc.dart';
import 'package:pokedex/bloc/pokemon/pokemon_event.dart';
import 'package:pokedex/bloc/pokemon/pokemon_state.dart';
import 'package:pokedex/models/pokemon/pokemon_simple_model.dart';
import 'package:pokedex/routes/names_routes.dart';
import 'package:pokedex/styles/color_theme.dart';
import 'package:pokedex/utils/constants.dart';

class PokedexPage extends HookWidget {
  const PokedexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final TextEditingController searchController =
        useTextEditingController(text: "");

    useEffect(() {
      context.read<PokemonBloc>().add(PokemonSimpleListResquest(page: 0));
      return null;
    }, []);

    final bool isDarkMode = themeNotifier.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Stack(
          children: [
            Text(
              'Pokédex',
              style: TextStyle(
                fontFamily: 'PokemonHollow',
                fontSize: 40,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 6
                  ..color = ColorTheme.darkCyan,
              ),
            ),
            const Text(
              'Pokédex',
              style: TextStyle(
                fontFamily: 'PokemonSolid',
                fontSize: 40,
                color: ColorTheme.yellow,
              ),
            ),
          ],
        ),
        backgroundColor: ColorTheme.red,
        toolbarHeight: 80,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              themeNotifier.toggleTheme();
            },
          ),
        ],
      ),
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state.pokemonSimpleListStatus == RequestStatus.loadInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.pokemonSimpleListStatus ==
              RequestStatus.loadSuccess) {
            return HookBuilder(
              builder: (context) {
                final ValueNotifier<List<PokemonSimple>> pokemonList =
                    useState(state.pokemonSimpleList!);
                final ValueNotifier<bool> filterByFavorite = useState(false);

                filterPokemons() {
                  pokemonList.value = state.pokemonSimpleList!.where(
                    (pokemon) {
                      if (searchController.value.text == "") {
                        if (filterByFavorite.value) {
                          return state.favoritePokemons!.contains(pokemon.id);
                        } else {
                          return true;
                        }
                      } else {
                        if (filterByFavorite.value) {
                          return state.favoritePokemons!.contains(pokemon.id) &&
                              pokemon.name
                                  .startsWith(searchController.value.text);
                        } else {
                          return pokemon.name
                              .startsWith(searchController.value.text);
                        }
                      }
                    },
                  ).toList();
                }

                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: searchController,
                                onChanged: (_) {
                                  filterPokemons();
                                },
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.search,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  hintText: "Buscar por nombre",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                filterByFavorite.value
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Theme.of(context).iconTheme.color,
                                size: 24,
                              ),
                              tooltip: 'Filtrar',
                              onPressed: () {
                                filterByFavorite.value =
                                    !filterByFavorite.value;

                                filterPokemons();
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GridPokemons(
                          pokemonList: pokemonList.value,
                          favoritePokemons: state.favoritePokemons!,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state.pokemonSimpleListStatus ==
              RequestStatus.loadFailed) {
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

class GridPokemons extends StatelessWidget {
  const GridPokemons({
    Key? key,
    required this.pokemonList,
    required this.favoritePokemons,
    required this.isDarkMode, 
  }) : super(key: key);

  final List<PokemonSimple> pokemonList;
  final List<int> favoritePokemons;
  final bool isDarkMode; 

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: pokemonList.length,
      itemBuilder: (context, index) {
        return Card(
          color: isDarkMode ? Colors.grey[850] : Theme.of(context).cardColor,  
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                NamesRoutes.description + "/" + pokemonList[index].id.toString(),
              );
            },
            child: GridTile(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (favoritePokemons.contains(pokemonList[index].id)) {
                              context.read<PokemonBloc>().add(
                                RemoveFavoritePokemon(id: pokemonList[index].id),
                              );
                            } else {
                              context.read<PokemonBloc>().add(
                                AddFavoritePokemon(id: pokemonList[index].id),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              favoritePokemons.contains(pokemonList[index].id)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Theme.of(context).iconTheme.color,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Image.network(pokemonList[index].imageUrl),
                    Text(pokemonList[index].name)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
