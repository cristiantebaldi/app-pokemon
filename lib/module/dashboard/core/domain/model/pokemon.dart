class Pokemon {
  String? name;
  String? pokemonURL;

  Pokemon({this.name, this.pokemonURL});

  static Pokemon fromJson(Map<String, dynamic> json) {
    return Pokemon(
        name: upperCaseFirstCaracter(json['name']),
        pokemonURL: json['url']
    );
  }
}

class PokemonURLInfo {
  String? image;
  String? pokedex;
  String? name;

  PokemonURLInfo({this.image, this.pokedex, this.name});

  static PokemonURLInfo fromJson(Map<String, dynamic> json) {
    return PokemonURLInfo(
      image: json['sprites']['other']['home']['front_default'],
      pokedex: json['id'].toString(),
      name: upperCaseFirstCaracter(json['name']),
    );
  }
}

String upperCaseFirstCaracter(String name) {
  if (name.isEmpty) return "";
  return name[0].toUpperCase() + name.substring(1);
}