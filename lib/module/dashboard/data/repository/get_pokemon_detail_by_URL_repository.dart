import 'package:pokeapi/gateway/pokeapi.dart';
import 'package:pokeapi/module/dashboard/core/domain/model/pokemon.dart';

class GetPokemonDetailByURLRepository {
  final Pokeapi pokeapi;

  GetPokemonDetailByURLRepository({required this.pokeapi});

  Future<PokemonURLInfo> call(String pokemonURL) async {
    return pokeapi.getPokemonDetailByURL(pokemonURL);
  }
}