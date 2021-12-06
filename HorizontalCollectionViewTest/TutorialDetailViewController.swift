//
//  TutorialDetailViewController.swift
//  HorizontalCollectionViewTest
//
//  Created by Ethan Scott on 12/5/21.
//

import UIKit

class TutorialDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var tutorialTitleLabel: UILabel!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var notesHeaderLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var notesView: UIView!
    

    private var collectionViewImages: [String] = ["avengersposter", "hungergamesposter", "LOTRposter"]
    private var indexOfCellBeforeDragging = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesView.layer.masksToBounds = false
        notesView.layer.shadowOpacity = 0.35
        notesView.layer.shadowRadius = 2
        notesView.layer.shadowOffset = CGSize(width: 0, height: 2)
        notesView.layer.shadowColor = UIColor.black.cgColor
        notesView.backgroundColor = .white
        notesView.layer.cornerRadius = 12
//        notesView.applyShadowWithCornerRadius(color: .gray, opacity: 0.35, radius: 0.5, edge: AIEdge.Bottom_Right, shadowSpace: 2.0, cornerRadius: 12)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionViewInsets()
    }

    //MARK: - CollectionView DATA SOURCE FUNCTIONS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tutorialCell", for: indexPath) as? TutorialCollectionViewCell else {return UICollectionViewCell()}
        
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
    
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(collectionViewImages.count - 1, index))
        
        return safeIndex
    }
    
    private func configureCollectionViewInsets() {
        let inset: CGFloat = 15
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
