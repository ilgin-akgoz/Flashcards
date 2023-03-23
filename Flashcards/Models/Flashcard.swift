//
//  Flashcard.swift
//  Flashcards
//
//  Created by Ilgın Akgöz on 15.02.2023.
//

import Foundation
import UIKit

struct Flashcard {
    let question: String
    let answer: String
    var isShowingAnswer: Bool = false
    let color: UIColor
}
