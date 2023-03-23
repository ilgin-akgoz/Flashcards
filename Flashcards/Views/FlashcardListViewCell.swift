//
//  FlashcardListViewCell.swift
//  Flashcards
//
//  Created by Ilgın Akgöz on 15.02.2023.
//

import UIKit

class FlashcardListViewCell: UICollectionViewCell {
    let cornerRadius: CGFloat = 8.0
    
    @IBOutlet weak var highlightIndicator: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            highlightIndicator.isHidden = !isSelected
        }
    }
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
            
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    func configure(_ text: String, _ color: UIColor) {
        questionLabel.text = text
        contentView.backgroundColor = color
    }
    
}
