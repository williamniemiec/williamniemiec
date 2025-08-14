import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_rover/api/api_service.dart';
import 'package:recipe_rover/bloc/recipe_bloc.dart';
import 'package:recipe_rover/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Rover',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => RecipeBloc(ApiService()),
        child: const HomeScreen(),
      ),
    );
  }
}
