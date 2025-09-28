import 'package:pokeapi/gateway/pokeapi.dart';
import 'package:pokeapi/module/dashboard/controller/dashboard_controller.dart';
import 'package:pokeapi/module/dashboard/core/domain/usecase/fetch_pokemon_usecase.dart';
import 'package:pokeapi/module/dashboard/core/domain/usecase/get_pokemon_by_name_pokedex_usecase.dart';
import 'package:pokeapi/module/dashboard/core/domain/usecase/get_pokemon_detail_by_URL_usecase.dart';
import 'package:pokeapi/module/dashboard/data/repository/fetch_pokemon_repository.dart';
import 'package:pokeapi/module/dashboard/data/repository/get_pokemon_by_name_pokedex_repository.dart';
import 'package:pokeapi/module/dashboard/data/repository/get_pokemon_detail_by_URL_repository.dart';

class DashboardControllerDI {
  static DashboardController? dashboardController;

  static DashboardController getInstance({required Function setState}) {
    Pokeapi pokeapi = Pokeapi();

    final FetchPokemonRepository fetchPokemonRepository = FetchPokemonRepository(
        pokeapi: pokeapi
    );
    final FetchPokemonUsecase fetchPokemonUsecase = FetchPokemonUsecase(
        fetchPokemonRepository: fetchPokemonRepository
    );

    final GetPokemonByNamePokedexRepository getPokemonByNamePokedexRepository = GetPokemonByNamePokedexRepository(
        pokeapi: pokeapi
    );
    final GetPokemonByNamePokedexUsecase getPokemonByNamePokedexUsecase = GetPokemonByNamePokedexUsecase(
        getPokemonByNamePokedexRepository: getPokemonByNamePokedexRepository
    );

    final GetPokemonDetailByURLRepository getPokemonDetailByURLRepository = GetPokemonDetailByURLRepository(
        pokeapi: pokeapi
    );
    final GetPokemonDetailByURLUsecase getPokemonDetailByURLUsecase = GetPokemonDetailByURLUsecase(
        getPokemonDetailByURLRepository: getPokemonDetailByURLRepository
    );


    dashboardController ??= DashboardController(
      fetchPokemonUsecase: fetchPokemonUsecase,
      getPokemonByNamePokedexUsecase: getPokemonByNamePokedexUsecase,
      getPokemonDetailByURLUsecase: getPokemonDetailByURLUsecase,
      setState: setState,
    );

    return dashboardController!;
  }
}