//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Mehmet Eroğlu on 7.03.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokemondId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolution: String!
    private var _pokemonUrl: String!
    
    var name: String {
        return _name
    }
    
    var pokemonId: Int {
        return _pokemondId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolution: String {
        if _nextEvolution == nil {
            _nextEvolution = ""
        }
        return _nextEvolution
    }
    
    init(name: String, pokemonId: Int) {
        self._name = name
        self._pokemondId = pokemonId
        self._pokemonUrl = "\(BASE_URL)\(POKEMON_URL)\(pokemonId)"
    }
    
    func downloadPokemonDetail(complited: @escaping DownloadComplete) {
        Alamofire.request(self._pokemonUrl).responseJSON { (response) in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? Int {
                    self._weight = "\(weight)"
                }
                
                if let height = dict["height"] as? Int {
                    self._height = "\(height)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, AnyObject>], types.count > 0 {
                    if let type = types[0]["type"] as? Dictionary<String, AnyObject> {
                        if let name = type["name"] as? String {
                            self._type = name
                        }
                    }
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let type = types[x]["type"] as? Dictionary<String, AnyObject> {
                                if let name = type["name"] as? String {
                                    self._type += "/\(name.capitalized)"
                                }
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
            }
            complited()
        }
    }
}
