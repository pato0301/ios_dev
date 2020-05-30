import Foundation

struct PokemonListResults: Codable {
    let results: [PokemonListResult]
}

struct PokemonListResult: Codable {
    let name: String
    let url: String
}

struct PokemonResult: Codable {
    let id: Int
    let name: String
    let types: [PokemonTypeEntry]
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

struct Pokedex {
 
 var caught = [String: Bool]()

 }

struct PokemonSprite: Codable {
    
    let name: String
    let sprites: SpriteInfo
    
}

struct SpriteInfo: Codable {
    
    let front_default: String
    let front_shiny: String
}

struct PokemonSpecies: Codable {
    
    let name: String
    var species : SpeciesInfo
    
}

struct SpeciesInfo: Codable {

    let name : String
    let url: String
}

struct FlavorTextEntries: Codable {
    
    let flavor_text_entries: [FlavorText]
    //let language:
    
}

struct FlavorText: Codable {
    
    let flavor_text: String
    let language : Languages
    let version : Version
    
}

struct Languages: Codable {
    
    let name: String
    let url: String
}

struct Version: Codable {
    
    let name: String
    let url: String
}
