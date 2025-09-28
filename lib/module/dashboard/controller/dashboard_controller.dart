import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokeapi/module/dashboard/core/domain/model/pokemon.dart';
import 'package:pokeapi/module/dashboard/core/domain/usecase/fetch_pokemon_usecase.dart';
import 'package:pokeapi/module/dashboard/core/domain/usecase/get_pokemon_by_name_pokedex_usecase.dart';
import 'package:pokeapi/module/dashboard/core/domain/usecase/get_pokemon_detail_by_URL_usecase.dart';

class DashboardController {
  final TextEditingController searchController = TextEditingController();
  bool isDark = false;
  bool isSearching = false;
  bool pokemonNotFound = false;
  List<PokemonURLInfo> pokemonsDetails = [];
  List<Pokemon> pokemons = [];
  PokemonURLInfo? searchedPokemon;
  Timer? _debounce;
  Function setState;

  final FetchPokemonUsecase fetchPokemonUsecase;
  final GetPokemonByNamePokedexUsecase getPokemonByNamePokedexUsecase;
  final GetPokemonDetailByURLUsecase getPokemonDetailByURLUsecase;

  DashboardController({required this.fetchPokemonUsecase, required this.getPokemonByNamePokedexUsecase, required this.getPokemonDetailByURLUsecase, required this.setState});

  Future fetchPokemon() async {
    setState(() {});
    pokemons = await fetchPokemonUsecase();
    List<PokemonURLInfo> tempPokemonList = [];
    for (var pokemon in pokemons) {
      if (pokemon.pokemonURL != null) {
        tempPokemonList.add(await getPokemonDetailByURLUsecase(pokemon.pokemonURL!));
      }
    }
    setState(() {
      pokemonsDetails = tempPokemonList;
    });
  }


  Future<PokemonURLInfo> searchPokemon(String pokemonNamePokedex) async {
    searchedPokemon = await getPokemonByNamePokedexUsecase(pokemonNamePokedex);
    return searchedPokemon!;
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          searchedPokemon = null;
          isSearching = false;
          pokemonNotFound = false;
        });
        return;
      }

      setState(() {
        isSearching = true;
        pokemonNotFound = false;
      });

      try {
        final result = await searchPokemon(query);
        setState(() {
          searchedPokemon = result;
          isSearching = false;
        });
      } catch (e) {
        setState(() {
          pokemonNotFound = true;
          searchedPokemon = null;
          isSearching = false;
        });
      }
    });
  }
}
