//
//  ViewController.swift
//  PokemonApp
//
//  Created by Mehmet Eroğlu on 7.03.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//

import UIKit
import AVFoundation

class PokemonViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var isSearchMode = false
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let pokeName = row["identifier"]!
                let poke = Pokemon(name: pokeName, pokemonId: pokeId)
                pokemons.append(poke)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func musicButtonTapped(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            UIView.animate(withDuration: 0.3) {
                sender.alpha = 0.5
            }
        } else {
            musicPlayer.play()
            UIView.animate(withDuration: 0.3) {
                sender.alpha = 1.0
            }
        }
    }
    
    // MARK: -Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailViewController" {
            if let destinationVC = segue.destination as? PokemonDetailViewController {
                if let poke = sender as? Pokemon {
                    destinationVC.pokemon = poke
                }
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension PokemonViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearchMode {
            return filteredPokemons.count
        }
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let pokeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCVCell", for: indexPath) as? PokeCVCell {
            let poke : Pokemon!
            if isSearchMode {
                poke = filteredPokemons[indexPath.row]
            } else {
                poke = pokemons[indexPath.row]
            }
            pokeCell.configureCell(pokemon: poke)
            return pokeCell
        } else {
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension PokemonViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let poke: Pokemon!
        if isSearchMode {
            poke = filteredPokemons[indexPath.row]
        } else {
            poke = pokemons[indexPath.row]
        }
        performSegue(withIdentifier: "PokemonDetailViewController", sender: poke)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PokemonViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width/3 - 10
        return CGSize(width: width, height: width)
    }
}

// MARK: - UISearchBarDelegate
extension PokemonViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearchMode = false
            collectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.view.endEditing(true)
            }
        } else {
            isSearchMode = true
            let lowercasedSearchString = searchBar.text!.lowercased()
            filteredPokemons = pokemons.filter({$0.name.range(of: lowercasedSearchString) != nil})
            collectionView.reloadData()
        }
    }
}
