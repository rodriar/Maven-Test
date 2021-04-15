//
//  SWServices.swift
//  MavenTest
//
//  Created by Rodrigo Arsuaga on 4/14/21.
//  Copyright © 2021 AustinSoftware. All rights reserved.
//

import Foundation

class SWServices {

    class func getCharacterByID(
        id: Int,
        success: @escaping (_ user: SWCharacter) -> Void,
        failure: @escaping (_ error: Error) -> Void
    ) {
        APIClient.request(
            .get,
            url: "people/\(id)/",
            success: { response, _ in
                guard
                    let userDictionary = response as? [String: Any],
                    let character = SWCharacter(dictionary: userDictionary)
                else {
                    failure(App.error(
                        domain: .parsing,
                        localizedDescription: "Could not parse a valid character".localized
                    ))
                    return
                }
                success(character)
            },
            failure: failure
        )
    }

    class func getAllFilms(
        success: @escaping (_ films: [Film]) -> Void,
        failure: @escaping (_ error: Error) -> Void
    ) {
        APIClient.request(
            .get,
            url: "films/",
            success: { response, _ in
                guard
                    let filmsDictionary = response["results"] as? [[String: Any]]

                else {
                    failure(App.error(
                        domain: .parsing,
                        localizedDescription: "Could not parse a valid films".localized
                    ))
                    return
                }

                let films = filmsDictionary.map({Film(dictionary: $0)!})
                success(films)
            },
            failure: failure
        )
    }

    class func getAllCharacters(
        page: Int,
        success: @escaping (_ films: [SWCharacter]) -> Void,
        failure: @escaping (_ error: Error) -> Void
    ) {
        APIClient.request(
            .get,
            url: "people/",
            params: ["page": page],
            success: { response, _ in
                guard
                    let userDictionary = response["results"] as? [[String: Any]]

                else {
                    failure(App.error(
                        domain: .parsing,
                        localizedDescription: "Could not parse a valid character".localized
                    ))
                    return
                }

                let characters = userDictionary.map({SWCharacter(dictionary: $0)!})
                success(characters)
            },
            failure: failure
        )
    }
}
