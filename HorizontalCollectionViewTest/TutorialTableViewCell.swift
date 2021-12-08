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
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var nameAndStatusStackView: UIStackView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
       setUpView()
    }
    
    

    //MARK: - Actions
    @IBAction func tutorialStatusButtonTapped(_ sender: Any) {
        
    }
    
    func setUpView() {
        backgroundColor = .clear
        
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowOffset = CGSize(width: 0.5, height: 2)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = 12
        
//        shadowView.applyShadowWithCornerRadius(color: .gray, opacity: 0.35, radius: 2, edge: AIEdge.Bottom_Right, shadowSpace: 0.5, cornerRadius: 12)
        
        cellView.layer.cornerRadius = 4
        nameAndStatusStackView.clipsToBounds = true
        nameAndStatusStackView.layer.cornerRadius = 4
        nameAndStatusStackView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner] // Top right corner, Top left corner respectively
        
        tutorialStatusButton.layer.borderWidth = 1.5
        tutorialStatusButton.layer.cornerRadius = 14
    }
    
    
    
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

enum AIEdge:Int {
    case
    Top,
    Left,
    Bottom,
    Right,
    Top_Left,
    Top_Right,
    Bottom_Left,
    Bottom_Right,
    All,
    None
}

extension UIView {
        
    func applyShadowWithCornerRadius(color:UIColor, opacity:Float, radius: CGFloat, edge:AIEdge, shadowSpace:CGFloat, cornerRadius: CGFloat)    {

        var sizeOffset:CGSize = CGSize.zero
        
        switch edge {
        case .Top:
            sizeOffset = CGSize(width: 0, height: -shadowSpace)
        case .Left:
            sizeOffset = CGSize(width: -shadowSpace, height: 0)
        case .Bottom:
            sizeOffset = CGSize(width: 0, height: shadowSpace)
        case .Right:
            sizeOffset = CGSize(width: shadowSpace, height: 0)
            
            
        case .Top_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: -shadowSpace)
        case .Top_Right:
            sizeOffset = CGSize(width: shadowSpace, height: -shadowSpace)
        case .Bottom_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: shadowSpace)
        case .Bottom_Right:
            sizeOffset = CGSize(width: shadowSpace, height: shadowSpace)
            
            
        case .All:
            sizeOffset = CGSize(width: 0, height: 0)
        case .None:
            sizeOffset = CGSize.zero
        }

        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true

        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = sizeOffset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false

        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
    }
}
