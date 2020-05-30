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
    
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""

        loadSprites()
        loadPokemon()
    }
    
    func loadSprites(){
        URLSession.shared.dataTask(with: URL(string: url)!){ (data, response, error) in
            guard let data = data else{
                return
            }
            do {
                let result = try JSONDecoder().decode(PokemonSprite.self, from: data)
                DispatchQueue.main.async {
                    let spriteURL = URL(string: result.sprites.front_default)
                    print(spriteURL!)
                    
                    let pokDataPic = try? Data(contentsOf: spriteURL!)
                    
                    self.pokemonPic.image = UIImage(data: pokDataPic!)
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }

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
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    @IBAction func toggleCatch(_ sender: UIButton) {
        
        print(pokedex)
        
        if pokedex.caught[nameLabel.text!] == false || pokedex.caught[nameLabel.text!] == nil{
            print("release")
            catchButton.setTitle("Release", for: .normal)
            pokedex.caught[nameLabel.text!] = true
            savedPokemon.set(true, forKey: nameLabel.text!)
        }
        else{
            print("catch")
            catchButton.setTitle("Catch", for: .normal)
            pokedex.caught[nameLabel.text!] = false
            savedPokemon.set(false, forKey: nameLabel.text!)
        }
        print("Button pressed \(pokedex.caught)")
        
        print("Button pressed \(pokedex.caught)")
        
        }
}
