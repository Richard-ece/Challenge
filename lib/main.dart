import 'package:flutter/material.dart';
import 'package:pokedex/pages/widget/theme.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const App(),
    ),
  );
}
