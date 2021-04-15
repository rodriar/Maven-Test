//
//  SWModels.swift
//  MavenTest
//
//  Created by Rodrigo Arsuaga on 4/14/21.
//  Copyright © 2021 AustinSoftware. All rights reserved.
//

import Foundation

struct SWCharacter: Equatable {
    var id: Int = 0
    let name: String
    let height: String
    let mass: String
    let hairColor: String
    let eyeColor: String
    let gender: String
    let filmsId: [Int]

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case height
        case mass
        case hairColor = "hair_color"
        case eyeColor = "eye_color"
        case gender
        case filmId = "films"

    }

    static func ==(lhs: SWCharacter, rhs: SWCharacter) -> Bool {
        return lhs.name == rhs.name && lhs.height == rhs.height
    }

    init?(dictionary: [String: Any]) {
        guard
            //            let id = dictionary[CodingKeys.id.rawValue] as? Int,
            let name = dictionary[CodingKeys.name.rawValue] as? String,
            let height = dictionary[CodingKeys.height.rawValue] as? String,
            let mass = dictionary[CodingKeys.mass.rawValue] as? String,
            let hairColor = dictionary[CodingKeys.hairColor.rawValue] as? String,
            let eyeColor = dictionary[CodingKeys.eyeColor.rawValue] as? String,
            let gender = dictionary[CodingKeys.gender.rawValue] as? String,
            let filmsURL = dictionary[CodingKeys.filmId.rawValue] as? [String]
        else {
            return nil
        }

        //        self.id = id
        self.name = name
        self.height = height
        self.mass = mass
        self.hairColor = hairColor
        self.eyeColor = eyeColor
        self.gender = gender
        let idStrings: [String] = filmsURL.map({
            var splittedString = $0.components(separatedBy: "/")
            splittedString.removeLast()
            return splittedString.popLast() ?? ""
        })
        self.filmsId = idStrings.map({Int($0)!})
    }

}


struct Film {
    let title: String
    let id: Int


    private enum CodingKeys: String, CodingKey {
        case id = "episode_id"
        case title
    }

    init?(dictionary: [String: Any]) {
        guard
            let title = dictionary[CodingKeys.title.rawValue] as? String,
            let id = dictionary[CodingKeys.id.rawValue] as? Int
        else {
            return nil
        }

        self.id = id
        self.title = title
    }
}
