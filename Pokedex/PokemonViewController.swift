import UIKit

var savedPokemon = UserDefaults.standard
var pokedex = Pokedex.init(caught: [ : ])

class PokemonViewController: UIViewController {
    var url: String!
    
    

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var pokemonPic: UIImageView!
    @IBOutlet var pokeDescription: UITextView!
    
    
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""
        pokeDescription.text = ""

        loadSprites()
        loadPokemon()
        loadSpecies()
    }
    
    // Get Species from Red Version of Pokemon
    func loadSpecies(){
        // First get the API's URL to get the text description
        URLSession.shared.dataTask(with: URL(string: url)!){ (data, response, error) in
        guard let data = data else{
            return
        }
        do {
                let result = try JSONDecoder().decode(PokemonSpecies.self, from: data)
                let urlText = result.species.url
            // Call the second URL to get the text and the version of the Pokemon
                URLSession.shared.dataTask(with: URL(string: urlText)!){ (dataText, response, error) in
                        guard let dataText = dataText else{
                            return
                        }
                        do {
                            let result = try JSONDecoder().decode(FlavorTextEntries.self, from: dataText)
                            for description in result.flavor_text_entries{
                                if description.language.name == "en" && description.version.name == "red"{
                                    self.pokeDescription.text = self.capitalize(text: description.flavor_text)
                                }
                            }
                            }
                            catch let error {
                                print(error)
                            }
                        }.resume()
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    // Load the image of the pokemon
    func loadSprites(){
        URLSession.shared.dataTask(with: URL(string: url)!){ (data, response, error) in
            guard let data = data else{
                return
            }
            do {
                let result = try JSONDecoder().decode(PokemonSprite.self, from: data)
                DispatchQueue.main.async {
                    let spriteURL = URL(string: result.sprites.front_default)
                    
                    let pokDataPic = try? Data(contentsOf: spriteURL!)
                    
                    self.pokemonPic.image = UIImage(data: pokDataPic!)
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }

    // Load Pokemon Name, Number and Type
    func loadPokemon() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)
                DispatchQueue.main.async {
                    self.navigationItem.title = self.capitalize(text: result.name)
                    self.nameLabel.text = self.capitalize(text: result.name)
                    self.numberLabel.text = String(format: "#%03d", result.id)
                    
                    if savedPokemon.bool(forKey: self.nameLabel.text!) == true {
                    
                    pokedex.caught[self.nameLabel.text!] = true
                    }
                    
                    if pokedex.caught[self.nameLabel.text!] == false || pokedex.caught[self.nameLabel.text!] == nil  {
                            
                        self.catchButton.setTitle("Catch", for: .normal)
                           
                       }
                    else if pokedex.caught[self.nameLabel.text!] == true {
                            
                        self.catchButton.setTitle("Release", for: .normal)

                       }

                    for typeEntry in result.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = self.capitalize(text: typeEntry.type.name)
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = self.capitalize(text: typeEntry.type.name)
                        }
                    }
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    // Cathc button. If you catch this pokemn then you can click the button
    // So you now know you have this one
    @IBAction func toggleCatch(_ sender: UIButton) {
        
        if pokedex.caught[nameLabel.text!] == false || pokedex.caught[nameLabel.text!] == nil{
            catchButton.setTitle("Release", for: .normal)
            pokedex.caught[nameLabel.text!] = true
            savedPokemon.set(true, forKey: nameLabel.text!)
        }
        else{
            catchButton.setTitle("Catch", for: .normal)
            pokedex.caught[nameLabel.text!] = false
            savedPokemon.set(false, forKey: nameLabel.text!)
        }
        }
}
