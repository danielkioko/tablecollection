//
//  TutorialTableViewCell.swift
//  HorizontalCollectionViewTest
//
//  Created by Ethan Scott on 12/2/21.
//

import UIKit

class TutorialTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var tutorialNameLabel: UILabel!
    @IBOutlet weak var tutorialStatusButton: UIButton!
    @IBOutlet weak var colorView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: - Actions
    @IBAction func tutorialStatusButtonTapped(_ sender: Any) {
        
    }
    
    
}
