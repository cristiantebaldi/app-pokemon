import 'package:pokeapi/gateway/pokeapi.dart';
import 'package:pokeapi/module/dashboard/core/domain/model/pokemon.dart';

class GetPokemonByNamePokedexRepository {
  final Pokeapi pokeapi;

  GetPokemonByNamePokedexRepository({required this.pokeapi});

  Future<PokemonURLInfo> call(String pokemonNamePokedex) async {
    return pokeapi.getPokemonByNamePokedex(pokemonNamePokedex);
  }
}