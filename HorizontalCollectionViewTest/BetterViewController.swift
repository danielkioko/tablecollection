//
//  BetterViewController.swift
//  HorizontalCollectionViewTest
//
//  Created by Ethan Scott on 12/1/21.
//

import UIKit

class BetterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "TutorialTableViewCell", bundle: nil), forCellReuseIdentifier: "TutorialTVC")
    }
    
    private var collectionViewImages: [String] = ["avengersposter", "hungergamesposter", "LOTRposter"]
    private var indexOfCellBeforeDragging = 0
    let tutorials: [Tutorials] = [Tutorials(title: " Training Request", status: "Finished", color: .cyan),
                                  Tutorials(title: " Adding a post", status: "Continue", color: .magenta),
                                  Tutorials(title: " Using S61C - Messenger", status: "Start", color: .darkGray),
                                  Tutorials(title: " Training Progress", status: "Start", color: .darkGray)]

    
    //MARK: - TableView DataSource Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutorials.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "TutorialTVC", for: indexPath) as? TutorialTableViewCell else {return UITableViewCell()}
        
        cell.colorView.backgroundColor = tutorials[indexPath.row].color
        cell.tutorialNameLabel.text = tutorials[indexPath.row].title
        cell.tutorialStatusButton.titleLabel?.text = tutorials[indexPath.row].status
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
   
    
    
    //MARK: - CollectionView DataSource Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tutCell", for: indexPath) as? TutorialCollectionViewCell else {return UICollectionViewCell()}
        
        cell.image.image = UIImage(named: collectionViewImages[indexPath.row])
        cell.image.layer.cornerRadius = 50
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        let indexOfMajorCell = self.indexOfMajorCell()
        
        let swipeVelocityThreshold: CGFloat = 5.0
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < collectionViewImages.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = collectionViewLayout.itemSize.width * CGFloat(snapToIndex)
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
            scrollView.contentOffset = CGPoint(x: toValue, y: 0)
            scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
        let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
        collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    
    
    //MARK: - Helper Functions
    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(collectionViewImages.count - 1, index))
        
        return safeIndex
    }

}//End of class

struct Tutorials {
    
    var title: String
    var status: String
    var color: UIColor
    
}