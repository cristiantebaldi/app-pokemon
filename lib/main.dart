import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokeapi/pokemon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeAPI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const MyHomePage( title: 'Dados PokeApi'
      ),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDark = false;
  List<PokemonURLInfo> pokemonsDetails = [];
  final TextEditingController _searchController = TextEditingController();

  PokemonURLInfo? _searchedPokemon;
  bool _isSearching = false;
  bool _pokemonNotFound = false;
  Timer? _debounce;

  Future<void> _fetchPokemons() async {
    final dio = Dio();

    final response = await dio.get('https://pokeapi.co/api/v2/pokemon/?limit=20&offset=20');
    List<Pokemon> pokemons = response.data['results'].map<Pokemon>((element) {
      return Pokemon.fromJson(element);
    }).toList();

    List<PokemonURLInfo> tempPokemonList = [];

    for (var pokemon in pokemons) {
      if (pokemon.pokemonURL != null) {
        final pokemonDetailResponse = await dio.get(pokemon.pokemonURL!);
        tempPokemonList.add(PokemonURLInfo.fromJson(pokemonDetailResponse.data));
      }
    }

    setState(() {
      pokemonsDetails = tempPokemonList;
    });
  }

  Future<PokemonURLInfo> _searchPokemon(String pokemonNamePokedex) async {
    final dio = Dio();
    final response = await dio.get('https://pokeapi.co/api/v2/pokemon/${pokemonNamePokedex.toLowerCase()}');
    return PokemonURLInfo.fromJson(response.data);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          _searchedPokemon = null;
          _isSearching = false;
          _pokemonNotFound = false;
        });
        return;
      }

      setState(() {
        _isSearching = true;
        _pokemonNotFound = false;
      });

      try {
        final result = await _searchPokemon(query);
        setState(() {
          _searchedPokemon = result;
          _isSearching = false;
        });
      } catch (e) {
        setState(() {
          _pokemonNotFound = true;
          _searchedPokemon = null;
          _isSearching = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPokemons();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Widget _buildBodyContent() {
    if (_searchController.text.isNotEmpty) {
      if (_isSearching) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_pokemonNotFound) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://static.wikia.nocookie.net/pkmnshuffle/images/0/0b/Pikachu_%28Teary%29.png/revision/latest?cb=20170410234512',
                height: 100,
              ),
              const SizedBox(height: 16),
              const Text(
                'Pokémon Não Encontrado!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        );
      }
      if (_searchedPokemon != null) {
        return Center(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(_searchedPokemon!.image ?? '', height: 180),
                  const SizedBox(height: 16),
                  Text(
                    _searchedPokemon!.name ?? 'Nome não encontrado',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pokédex: #${_searchedPokemon!.pokedex}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return Container();
    } else {
      return GridView.builder(
        itemCount: pokemonsDetails.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          final pokemon = pokemonsDetails[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.network(pokemon.image ?? '',
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pokemon.name ?? 'Desconhecido',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text('Nº ${pokemon.pokedex}'),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
    );

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Buscar: Nome/Nº Pokédex...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _onSearchChanged(_searchController.text),
                  ),
                  Tooltip(
                    message: 'Change brightness mode',
                    child: IconButton(
                      isSelected: isDark,
                      onPressed: () {
                        setState(() {
                          isDark = !isDark;
                        });
                      },
                      icon: const Icon(Icons.wb_sunny_outlined),
                      selectedIcon: const Icon(Icons.brightness_2_outlined),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _buildBodyContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}