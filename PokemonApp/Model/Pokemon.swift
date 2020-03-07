//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Mehmet Eroğlu on 7.03.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//

import Foundation

class Pokemon {
    var _name: String!
    var _pokemondId: Int!
    
    var name: String {
        return _name
    }
    
    var pokemonId: Int {
        return _pokemondId
    }
    
    init(name: String, pokemonId: Int) {
        self._name = name
        self._pokemondId = pokemonId
    }
}
