import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/pages/widget/theme.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/bloc/pokemon/pokemon_bloc.dart';
import 'package:pokedex/routes/names_routes.dart';
import 'package:pokedex/routes/routes.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _pokemonBloc = PokemonBloc();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<PokemonBloc>(
                create: (BuildContext context) => _pokemonBloc,
              ),
            ],
            child: MaterialApp(
              theme: themeNotifier.isDarkMode ? ThemeData.dark() : ThemeData.light(),
              debugShowCheckedModeBanner: false,
              initialRoute: NamesRoutes.home,
              onGenerateRoute: onGenerateRoute,
            ),
          );
        },
      ),
    );
  }
}
