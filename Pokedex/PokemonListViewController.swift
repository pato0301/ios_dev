import UIKit

class PokemonListViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var pokemonSearch: UISearchBar!
    
    
    var pokemon: [PokemonListResult] = []
    
    var filteredPokemon = [PokemonListResult]()
        
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonSearch.delegate = self
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else {
            return
        }
        
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let entries = try JSONDecoder().decode(PokemonListResults.self, from: data)
                self.pokemon = entries.results
                self.filteredPokemon = self.pokemon
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return pokemon.count
        return filteredPokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = capitalize(text: filteredPokemon[indexPath.row].name)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPokemonSegue",
                let destination = segue.destination as? PokemonViewController,
                let index = tableView.indexPathForSelectedRow?.row {
            destination.url = filteredPokemon[index].url//pokemon[index].url
        }
    }
    
    func searchBar(_ pokemonSearch: UISearchBar, textDidChange searchText: String){
        
        print("search text \(searchText)")
        print(filteredPokemon)
        
        let searchPokText : String = searchText.lowercased()
        
//        let wantedPokemon = pokemon.map { $0.name }
        
        if searchText.isEmpty {
            
            filteredPokemon = pokemon
            tableView.reloadData()
            return
        }
        
        filteredPokemon.removeAll()
        
        for pok in pokemon{
            if pok.name.contains(searchPokText){
                filteredPokemon.append(pok)
                tableView.reloadData()
            }
        }
    }
}
