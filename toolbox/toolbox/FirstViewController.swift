//
//  FirstViewController.swift
//  toolbox
//
//  Created by Sergio Sánchez Sánchez on 09/09/2019.
//  Copyright © 2019 Sergio Sánchez Sánchez. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var ageSliderView: UISlider!
    @IBOutlet weak var currentAgeSelectedLabel: UILabel!
    @IBOutlet weak var currentUserNameTextView: UITextField!
    
    private var userAge: Int = 0
    private var userName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateAgeLabel()
    }
    
    func updateAgeLabel(){
        self.userAge = Int(self.ageSliderView.value)
        self.currentAgeSelectedLabel.text = "(\(self.userAge) años)"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Cerramos el teclado
        textField.resignFirstResponder()
        
    
        
        //Indicamos la finalización de la edición del textField
        return true
    }
        

    @IBAction func onSliderMoved(_ sender: UISlider) {
        self.updateAgeLabel()
    }
    
    @IBAction func onValidateDateClicked(_ sender: UIButton) {
        
        if let userName = self.currentUserNameTextView.text {
            self.userName = userName
        }
       

        let shouldEnterTheParty = (userName.uppercased(with: nil) == "SERGIO") || (userAge>=18) //&&
        
        var alertTitle: String?
        
        if shouldEnterTheParty {
            alertTitle = "Bienvenido a la fiesta"
            self.view.backgroundColor = UIColor(red: 49.0/255.0, green: 237.0/255.0, blue: 93.0/255.0, alpha: 0.7)
        } else {
            alertTitle = "Lo siento, esta fiesta es privada. No tienes acceso...."
            self.view.backgroundColor = UIColor(red: 250.0/255.0, green: 50.0/250.0, blue: 50.0/255.0, alpha: 0.8)
        }
        
        let alertController = UIAlertController(title: "Acceso a la fiesta", message: alertTitle, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        show(alertController, sender: self)
        
    }
    
}

