import 'package:flutter/material.dart';
import 'package:pokeapi/module/dashboard/controller/dashboard_controller.dart';
import 'package:pokeapi/module/dashboard/di/controller.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late DashboardController dashboardController;

  @override
  void initState() {
    super.initState();
    dashboardController = DashboardControllerDI.getInstance(setState: setState);
    dashboardController.fetchPokemon();
  }

  Widget _buildBodyContent() {
    if (dashboardController.searchController.text.isNotEmpty) {
      if (dashboardController.isSearching) {
        return const Center(child: CircularProgressIndicator());
      }
      if (dashboardController.pokemonNotFound) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://static.thenounproject.com/png/65508-200.png',
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
      if (dashboardController.searchedPokemon != null) {
        return Center(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(dashboardController.searchedPokemon!.image ?? '', height: 180),
                  const SizedBox(height: 16),
                  Text(
                    dashboardController.searchedPokemon!.name ?? 'Nome não encontrado',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pokédex: #${dashboardController.searchedPokemon!.pokedex}',
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
        itemCount: dashboardController.pokemonsDetails.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          final pokemon = dashboardController.pokemonsDetails[index];
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
      brightness: dashboardController.isDark ? Brightness.dark : Brightness.light,
    );

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Dados Da PokeApi"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dashboardController.searchController,
                      decoration: const InputDecoration(
                        hintText: 'Buscar: Nome/Nº Pokédex...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: dashboardController.onSearchChanged,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => dashboardController.onSearchChanged(dashboardController.searchController.text),
                  ),
                  Tooltip(
                    message: 'Change brightness mode',
                    child: IconButton(
                      isSelected: dashboardController.isDark,
                      onPressed: () {
                        setState(() {
                          dashboardController.isDark = !dashboardController.isDark;
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
