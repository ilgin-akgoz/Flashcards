//
//  FlashcardUIColor.swift
//  Flashcards
//
//  Created by Ilgın Akgöz on 18.03.2023.
//

import Foundation
import UIKit

extension UIColor {
    static let flashcardColors = [
        UIColor(red: 1.00, green: 0.77, blue: 0.73, alpha: 1.00),
        UIColor(red: 0.99, green: 0.84, blue: 0.81, alpha: 1.00),
        UIColor(red: 0.98, green: 0.88, blue: 0.87, alpha: 1.00),
        UIColor(red: 0.97, green: 0.93, blue: 0.92, alpha: 1.00),
        UIColor(red: 0.91, green: 0.91, blue: 0.89, alpha: 1.00),
        UIColor(red: 0.85, green: 0.89, blue: 0.86, alpha: 1.00),
        UIColor(red: 0.93, green: 0.89, blue: 0.86, alpha: 1.00),
        UIColor(red: 1.00, green: 0.90, blue: 0.85, alpha: 1.00),
        UIColor(red: 1.00, green: 0.84, blue: 0.73, alpha: 1.00),
        UIColor(red: 1.00, green: 0.78, blue: 0.60, alpha: 1.00),
    ]
    
    static func randomFlashcardColor() -> UIColor {
            return flashcardColors.randomElement()!
    }
}
