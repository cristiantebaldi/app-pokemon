import 'package:pokeapi/module/dashboard/core/domain/model/pokemon.dart';
import 'package:pokeapi/module/dashboard/data/repository/fetch_pokemon_repository.dart';

class FetchPokemonUsecase {
  final FetchPokemonRepository fetchPokemonRepository;

  FetchPokemonUsecase({required this.fetchPokemonRepository});

  Future<List<Pokemon>> call() async {
    return await fetchPokemonRepository();
  }
}