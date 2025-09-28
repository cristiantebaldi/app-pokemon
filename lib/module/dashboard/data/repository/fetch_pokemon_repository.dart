import 'package:pokeapi/gateway/pokeapi.dart';
import 'package:pokeapi/module/dashboard/core/domain/model/pokemon.dart';

class FetchPokemonRepository {
  final Pokeapi pokeapi;

  FetchPokemonRepository({required this.pokeapi});

  Future<List<Pokemon>> call() async{
    return pokeapi.fetchPokemons();
  }
}