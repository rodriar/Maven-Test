//
//  RequirementTableViewCell.swift
//  Kobeyo
//
//  Created by Martin Zuniga on 7/30/18.
//  Copyright © 2018 Kobeyo. All rights reserved.
//

import Foundation
import UIKit

class CharacterCell: UITableViewCell {

    // MARK: - Constants

    static let cellIdentifier = "CharacterCell"
    static let nibName = "CharacterCell"
    static let rowHeight: CGFloat = 40

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var hairColorLabel: UILabel!
    @IBOutlet weak var eyeColorLabel: UILabel!



    // MARK: - Properties



    
    // MARK: - Setup

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configure(withCharacter character: SWCharacter) {
        nameLabel.text = character.name
        heightLabel.text = "Height: \(character.height)"
        massLabel.text = "Mass(Kg): \(character.mass)"
        hairColorLabel.text = "Hair color: \(character.hairColor)"
        eyeColorLabel.text = "Eye color: \(character.eyeColor)"
    }
}
