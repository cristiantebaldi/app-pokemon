import 'package:pokeapi/module/dashboard/core/domain/model/pokemon.dart';
import 'package:pokeapi/module/dashboard/data/repository/get_pokemon_detail_by_URL_repository.dart';

class GetPokemonDetailByURLUsecase {
  final GetPokemonDetailByURLRepository getPokemonDetailByURLRepository;

  GetPokemonDetailByURLUsecase({required this.getPokemonDetailByURLRepository});

  Future<PokemonURLInfo> call(String pokemonURL) async {
    return await getPokemonDetailByURLRepository(pokemonURL);
  }
}