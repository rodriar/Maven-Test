//
//  FirstViewModel.swift
//  MavenTest
//
//  Created by German Stabile on 11/2/18.
//  Copyright © 2018 Rootstrap Inc. All rights reserved.
//

import Foundation

protocol FirstViewModelDelegate: NetworkStatusDelegate {
    func didUpdateState(to state: FirstViewModelState)
    func updateTableView()
    func updatePickers()
}

enum FirstViewModelState {
    case loading
    case loadedCharacters
    case network(state: NetworkState)
}

class FirstViewModel {

    var state: FirstViewModelState = .network(state: .idle) {
        didSet {
            delegate?.didUpdateState(to: state)
        }
    }

    weak var delegate: FirstViewModelDelegate?

    var films: [Film] = []
    var characters: [SWCharacter] = []
    var filteredCharacters: [SWCharacter] = []
    var genders: [String] = ["male", "female", "unkown", "n/a"]
    var eyeColors: [String] = []
    var filmFilter: Film?
    var genderFilter: String?
    var eyeColorFilter: String?
    var currentPage = 1

    func getAllFilms() {
        SWServices.getAllFilms{ [weak self] films in
            self?.films = films
            self?.delegate?.updatePickers()
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.state = .network(state: .error("Oops Something went wrong. Try again later"))
        }
    }

    func filterCharacters() {
        filteredCharacters = characters.filter({isCharacterFiltered(character: $0)})
        delegate?.updateTableView()
    }

    func getMoreCharacters() {
        if currentPage == 1 {
            state = .loading
        }
        if currentPage < 6 {
            SWServices.getAllCharacters(page: currentPage) { [weak self] characters in
                guard let self = self else { return }
                characters.forEach { (character) in
                    if !self.eyeColors.contains(character.eyeColor) {
                        self.eyeColors.append(character.eyeColor)
                    }
                }
                self.characters.append(contentsOf: characters)
                self.currentPage += 1
                self.state = .loadedCharacters
                self.filterCharacters()
            } failure: { [weak self] error in
                guard let self = self else { return }
                self.state = .network(state: .error("Oops Something went wrong. Try again later"))
            }
        }
    }


    func isCharacterFiltered(character: SWCharacter) -> Bool {
        if let genderFilter = genderFilter, genderFilter != character.gender {
            return false
        }
        if let eyeColorFilter = eyeColorFilter, eyeColorFilter != character.eyeColor {
            return false
        }
        if let filmFilter = filmFilter, !character.filmsId.contains(filmFilter.id) {
            return false
        }
        return true

    }

}
