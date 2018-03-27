//
//  ViewController.swift
//  AlertController
//
//  Created by Evgeniy Ryshkov on 27.03.2018.
//  Copyright © 2018 Evgeniy Ryshkov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var labelText: String?
    var randNumber: Int?
    var maxRandNumber: UInt32?
    var attempt: Int?
    var isWin: Bool? {
        willSet{
            guard let value = newValue else { return }
            if value {
                startButton.isEnabled = true
                nextButton.isEnabled = false
                helpButton.isEnabled = false
                settingsButton.isEnabled = true
            }else{
                startButton.isEnabled = false
                nextButton.isEnabled = true
                helpButton.isEnabled = true
                settingsButton.isEnabled = false
            }
            self.attempt = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maxRandNumber = 10
        self.label.text = ""
        isWin = true
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        self.labelText = "Загадано число от 0 до \(maxRandNumber!). Угадайте его\n"
        isWin = false
        self.label.text = self.labelText
        
        self.randNumber = Int(arc4random_uniform(maxRandNumber! + 1))
        //print(randNumber!)
        alertWithTextField(title: "Начало игры", message: "Загадано число от 0 до \(maxRandNumber!). Угадайте его", style: .alert)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.attempt! += 1
        
        alertWithTextField(title: "Попытка №\(self.attempt!)", message: "Загадано число от 0 до \(maxRandNumber!). Угадайте его", style: .alert)
        
        if label.calculateMaxLines() > 7 {
            label.text = labelText
        }
    }
    
    @IBAction func helpButtonPressed(_ sender: UIButton) {
        var helpText = "Загаданное число "
        let helpNumber = arc4random_uniform(maxRandNumber! + 1)
        if self.randNumber! >= helpNumber {
            helpText += "не менее, чем \(helpNumber)"
        } else {
            helpText += "меньше, чем \(helpNumber)"
        }
        alert(title: "Подсказка", message: helpText, style: .alert)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Настройки", message: "Задайте максимальное число", preferredStyle: .alert)
        let action = UIAlertAction(title: "Задать", style: .default) { (action) in
            let text = alertController.textFields?.first?.text ?? "10"
            self.maxRandNumber = UInt32(text) ?? 10
        }
        
        alertController.addTextField { (textField) in
            textField.keyboardType = .decimalPad
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Reusable alerts
    
    func alertWithTextField(title: String, message: String, style: UIAlertControllerStyle){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            var text = alertController.textFields?.first?.text ?? ""
            text = text == "" ? "пустота" : text
            if Int(text) != self.randNumber {
                self.label.text! += "Попытка №\(self.attempt!). Это не \(text)!\n"
            }else{
                self.label.text! += "Попытка №\(self.attempt!). Это \(text)! Вы выиграли\n"
                self.isWin = true
            }
        }
        
        alertController.addTextField { (textField) in
            textField.keyboardType = .decimalPad
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, style: UIAlertControllerStyle){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

