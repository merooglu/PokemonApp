//
//  PokemonDetailViewController.swift
//  PokemonApp
//
//  Created by Mehmet Eroğlu on 7.03.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//

import UIKit
import Alamofire

class PokemonDetailViewController: UIViewController {

    // MARK: -Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokedexIdLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var evolutionLabel: UILabel!
    @IBOutlet weak var currentEvolutionImageView: UIImageView!
    @IBOutlet weak var nextEvolutionImageView: UIImageView!
    
    // MARK: - Variables
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemon.downloadPokemonDetail {
            // Whatever we write will only be called after network call is complete!
            self.downloadDescription()
            self.updateUI()
        }
    }
    
    fileprivate func downloadDescription() {
        let descUrl = "\(BASE_URL)\(DESCRİPTİON_URL)\(self.pokemon.pokemonId)/"
        Alamofire.request(descUrl).responseJSON { (response) in
            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                if let descriptions = descDict["descriptions"] as? [Dictionary<String, AnyObject>] {
                    if let description = descriptions[0]["description"] as? String {
                        self.descriptionLabel.text = description
                    }
                }
            }
        }
    }
    
    func updateUI() {
        nameLabel.text = pokemon.name.capitalized
        let pokemonImage = UIImage(named: "\(pokemon.pokemonId)")
        mainImageView.image = pokemonImage
        currentEvolutionImageView.image = pokemonImage
        pokedexIdLabel.text = "\(pokemon.pokemonId)"
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        typeLabel.text = pokemon.type
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
