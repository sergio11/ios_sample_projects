//
//  ViewController.swift
//  02-dices
//
//  Created by Sergio Sánchez Sánchez on 08/09/2019.
//  Copyright © 2019 Sergio Sánchez Sánchez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var imageViewDiceLeft: UIImageView!
    
    @IBOutlet weak var imageViewDiceRight: UIImageView!
    
    @IBOutlet weak var labelViewResult: UILabel!
    
    let diceImages : [String] = ["dice1", "dice2", "dice3", "dice4", "dice5", "dice6"]
    let nFaces : UInt32
    
    required init?(coder aDecoder: NSCoder) {
        nFaces = UInt32(diceImages.count)
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateRandomDices()
    }


    @IBAction func rollPressed(_ sender: Any) {
        generateRandomDices()
    }
    
    private func generateRandomDice() -> Int{
        return Int(arc4random_uniform(nFaces))
    }
    
    private func generateRandomDices(){
        
        //Generar aleatoriamente y cambiar el dado izquierdo
        let randomDiceIndexLeft = generateRandomDice()
        let nameImageDiceLeft = diceImages[randomDiceIndexLeft]
        //Generar aleatoriamente y cambiar el dado derecho
        let randomDiceIndexRight = generateRandomDice()
        let nameImageDiceRight = diceImages[randomDiceIndexRight]
        
        let sumDices = (randomDiceIndexLeft + 1) + (randomDiceIndexRight + 1)
        
        labelViewResult.text = String(sumDices)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: {
                        
                        self.imageViewDiceLeft.transform = CGAffineTransform(scaleX: 0.6, y: 0.6).concatenating(CGAffineTransform(rotationAngle: CGFloat.pi/2)).concatenating(CGAffineTransform(translationX: -100, y: 100))
                        
                        self.imageViewDiceRight.transform = CGAffineTransform(scaleX: 0.6, y: 0.6).concatenating(CGAffineTransform(rotationAngle: CGFloat.pi/2)).concatenating(CGAffineTransform(translationX: 100, y: 100))
                        
                        self.imageViewDiceRight.alpha = 0.0
                        self.imageViewDiceLeft.alpha = 0.0
                        
        }) { (completed) in
            
            self.imageViewDiceLeft.transform = CGAffineTransform.identity
            self.imageViewDiceRight.transform = CGAffineTransform.identity
            
            self.imageViewDiceRight.alpha = 1.0
            self.imageViewDiceLeft.alpha = 1.0
            
            
            self.imageViewDiceLeft.image = UIImage(named: nameImageDiceLeft)
            self.imageViewDiceRight.image = UIImage(named: nameImageDiceRight)
        }
        
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake{
            generateRandomDices()
        }
        
    }
}

