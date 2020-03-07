//
//  PokeCVCell.swift
//  PokemonApp
//
//  Created by Mehmet Eroğlu on 7.03.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//

import UIKit

class PokeCVCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon)  {
        nameLabel.text = pokemon.name.capitalized
        pokemonImageView.image = UIImage(named: "\(pokemon.pokemonId)")
    }
}
