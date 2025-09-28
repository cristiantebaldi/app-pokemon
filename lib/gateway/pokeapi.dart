import 'package:dio/dio.dart';
import 'package:pokeapi/module/dashboard/core/domain/model/pokemon.dart';

class Pokeapi {
  Future<List<Pokemon>> fetchPokemons() async {
    final dio = Dio();
    final response = await dio.get('https://pokeapi.co/api/v2/pokemon/?limit=20&offset=20');
    List<Pokemon> pokemons = response.data['results'].map<Pokemon>((element) {
      return Pokemon.fromJson(element);
    }).toList();

    return pokemons;
  }

  Future<PokemonURLInfo> getPokemonDetailByURL(String pokemonURL) async {
    final dio = Dio();
    final response = await dio.get(pokemonURL);
    return PokemonURLInfo.fromJson(response.data);
  }

  Future<PokemonURLInfo> getPokemonByNamePokedex(String pokemonNamePokedex) async {
    final dio = Dio();
    final response = await dio.get('https://pokeapi.co/api/v2/pokemon/${pokemonNamePokedex.toLowerCase()}');
    return PokemonURLInfo.fromJson(response.data);
  }
}
