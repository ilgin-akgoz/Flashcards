//
//  FlashcardListViewController.swift
//  Flashcards
//
//  Created by Ilgın Akgöz on 31.01.2023.
//

import UIKit

class FlashcardListViewController: UICollectionViewController {
    private var flashcardViewModel = FlashcardListViewModel()
    var selectedIndexPath: [IndexPath: Bool] = [:]
    
    lazy var selectBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didClickSelectButton(_:)))
        return barButtonItem
    }()
    
    lazy var deleteBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didClickTrashButton(_:)))
        return barButtonItem
    }()
    
    lazy var addBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(submit))
        return barButtonItem
    }()
    
    enum Mode {
        case view
        case select
    }
    
    var mode: Mode = .view {
        didSet {
            switch mode {
            case .view:
                for (key, value) in selectedIndexPath {
                    if value {
                        collectionView.deselectItem(at: key, animated: true)
                    }
                }
                
                selectedIndexPath.removeAll()
                
                selectBarButton.title = "Select"
                navigationItem.leftBarButtonItem = addBarButton
                collectionView.allowsMultipleSelection = false
            case .select:
                selectBarButton.title = "Cancel"
                navigationItem.leftBarButtonItem = deleteBarButton
                collectionView.allowsMultipleSelection = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flashcards"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = addBarButton
        navigationItem.rightBarButtonItem = selectBarButton
        
        readSavedFlashcards()
    }
    
    @objc private func submit() {
        let ac = UIAlertController(title: "Add a new flashcard", message: nil, preferredStyle: .alert)
        
        ac.addTextField { (textField) in
            textField.placeholder = "Question"
        }
        
        ac.addTextField { (textField) in
            textField.placeholder = "Answer"
        }
        
        let submitFlashcard = UIAlertAction(title: "Enter", style: .default) { [weak self, weak ac] _ in
            guard let question = ac?.textFields?[0].text else { return }
            guard let answer = ac?.textFields?[1].text else { return }
            self?.addFlashcard(question, answer)
        }
        
        ac.addAction(submitFlashcard)
        present(ac, animated: true)
    }
    
    @objc private func addFlashcard(_ question: String, _ answer: String) {
        let flashcard = Flashcard(
            question: question,
            answer: answer,
            color: UIColor.randomFlashcardColor()
        )
        flashcardViewModel.flashcards.insert(flashcard, at: 0)
        saveFlashcards()
        collectionView.reloadData()
    }
    
    private func saveFlashcards() {
        let dictionary = flashcardViewModel.flashcards.map { (card) -> [String: Any] in
            let colorData = try? NSKeyedArchiver.archivedData(withRootObject: card.color, requiringSecureCoding: false)
            return ["question": card.question, "answer": card.answer, "colorData": colorData ?? Data()]
        }
        
        UserDefaults.standard.set(dictionary, forKey: "flashcards")
    }
    
    private func readSavedFlashcards() {
        if let dictionary = UserDefaults.standard.array(forKey: "flashcards") as? [[String: Any]] {
            let savedCards = dictionary.compactMap { dictionary -> Flashcard? in
                guard let question = dictionary["question"] as? String,
                      let answer = dictionary["answer"] as? String,
                      let colorData = dictionary["colorData"] as? Data,
                      let color = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor else {
                    return nil
                }
                return Flashcard(question: question, answer: answer, color: color)
            }
            
            flashcardViewModel.flashcards.append(contentsOf: savedCards)
        }
    }
    
    @objc private func didClickSelectButton(_ sender: UIBarButtonItem) {
        mode = mode == .view ? .select : .view
    }
    
    @objc private func didClickTrashButton(_ sender: UIBarButtonItem) {
        var deleteItems: [IndexPath] = []
        for (key, value) in selectedIndexPath {
            if value {
                deleteItems.append(key)
            }
        }
        
        for i in deleteItems.sorted(by: { $0.item > $1.item }) {
            flashcardViewModel.flashcards.remove(at: i.item)
        }
        
        saveFlashcards()
        collectionView.deleteItems(at: deleteItems)
        selectedIndexPath.removeAll()
    }
}

extension FlashcardListViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flashcardViewModel.flashcards.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var flashcardCell = FlashcardListViewCell()
        let flashcard = flashcardViewModel.flashcards[indexPath.item]
        
        if let questionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? FlashcardListViewCell {
            questionCell.configure(flashcard.question, flashcard.color)
            flashcardCell = questionCell
        }
        
        return flashcardCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mode {
        case .view:
            collectionView.deselectItem(at: indexPath, animated: true)
            
            if let cell = collectionView.cellForItem(at: indexPath) as? FlashcardListViewCell {
                var flashcard = flashcardViewModel.flashcards[indexPath.item]
                
                flashcard.isShowingAnswer.toggle()
                let textToShow = flashcard.isShowingAnswer ? flashcard.answer : flashcard.question
                cell.configure(textToShow, flashcard.color)
                
                let flipAnimationOptions: UIView.AnimationOptions = flashcard.isShowingAnswer ? .transitionFlipFromLeft : .transitionFlipFromRight
                UIView.transition(with: cell, duration: 1, options: flipAnimationOptions, animations: nil, completion: nil)
                
                flashcardViewModel.flashcards[indexPath.item] = flashcard
            }
        case .select:
            selectedIndexPath[indexPath] = true
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mode == .select {
            selectedIndexPath[indexPath] = false
        }
    }
}
