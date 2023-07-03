//
//  ViewController.swift
//  Miliestone 7-9
//
//  Created by Артем Чжен on 15/04/23.
//

import UIKit

class ViewController: UIViewController {
    var text: UILabel!
    var labelScore: UILabel!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var answer = String()
    var solutions = [String]()
    var arrayWords = [String]()
    var word = ""
    
    
    var score = 0 {
        didSet {
            labelScore.text = "\(score) life left"
        }
    }
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
        
        
        labelScore = UILabel()
        labelScore.translatesAutoresizingMaskIntoConstraints = false
        labelScore.textAlignment = .right
        labelScore.text = "Life: 7"
        view.addSubview(labelScore)
        
        text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.font = UIFont.systemFont(ofSize: 24)
        text.isUserInteractionEnabled = false
        text.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(text)

        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            labelScore.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            labelScore.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            text.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            text.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            text.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            text.topAnchor.constraint(equalTo: labelScore.topAnchor, constant: 80),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 300),
            buttonsView.heightAnchor.constraint(equalToConstant: 400),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 100),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -100)
        ])
        
        let width = 40
        let height = 50
        
        for row in 0..<4  {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
//                letterButton.setTitle("A", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped ), for: .touchUpInside)
                letterButton.layer.cornerRadius = 10
                letterButton.layer.borderColor = UIColor.gray.cgColor
                letterButton.layer.borderWidth = 1
                
                let frame = CGRect(x: (column * 20) + (column * width), y: (row * 20) + (row * height), width: width, height: height)
                letterButton.frame = frame
                buttonsView.addSubview(letterButton)
                
                letterButtons.append(letterButton)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }
    @objc func letterTapped(_ sender: UIButton) {
        var bitsInAnswer = [Character]()
        var bitsInButtons = [Character]()
        
        guard let buttonTitle = sender.titleLabel?.text else { return }
        sender.isHidden = true
        guard let meaning = text.text else { return }
        print(meaning)
        for bit in meaning {
            bitsInAnswer.append(bit)
        }
        for bit in answer {
            bitsInButtons.append(bit)
        }
        
        if answer.contains(buttonTitle) {
            for i in 0..<answer.count {
                if bitsInButtons[i] == Character(buttonTitle) {
                    bitsInAnswer[i] = Character(buttonTitle)
                }
                text.text? = ""
                for bit in bitsInAnswer {
                    text.text? += String(bit)
                }
                activatedButtons.append(sender)
                
                guard let meaningAnother = text.text else { return }
                if meaningAnother == answer {
                    let ac = UIAlertController(title: "You win", message: "Word is: \(answer)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: loadLevel))
                    present(ac, animated: true)
                }
            }
        } else {
            score -= 1
            if score == 0 {
                let ac = UIAlertController(title: "You lose", message: "Word is: \(answer)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: loadLevel))
                present(ac, animated: true)
            }
        }
    }
    
    func loadLevel(_ action: UIAlertAction? = nil) {
        var wordBits = [String]()
        var someString = [Character]()
        for btn in activatedButtons {
            btn.isHidden = false
        }
        score = 4
        text.text = "*****"
        
        if let levelFileURL = Bundle.main.url(forResource: "level", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for i in 0..<5 {
                    wordBits.append(lines[i])
                    for bit in lines[i] {
                        someString.append(bit)
                    }
                    someString.shuffle()
                }
                for i in 0..<someString.count {
                    letterButtons[i].setTitle(String(someString[i]), for: .normal)
                }
            }
            answer = wordBits.randomElement()!
            print(answer)
           
        }
    }
}

