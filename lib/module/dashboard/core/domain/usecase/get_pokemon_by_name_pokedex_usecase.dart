import 'package:pokeapi/module/dashboard/core/domain/model/pokemon.dart';
import 'package:pokeapi/module/dashboard/data/repository/get_pokemon_by_name_pokedex_repository.dart';

class GetPokemonByNamePokedexUsecase {
  final GetPokemonByNamePokedexRepository getPokemonByNamePokedexRepository;

  GetPokemonByNamePokedexUsecase({required this.getPokemonByNamePokedexRepository});

  Future<PokemonURLInfo> call(String pokemonNamePokedex) async {
    return await getPokemonByNamePokedexRepository(pokemonNamePokedex);
  }
}
