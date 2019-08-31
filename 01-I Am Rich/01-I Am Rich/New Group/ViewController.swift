//
//  ViewController.swift
//  01-I Am Rich
//
//  Created by Sergio Sánchez Sánchez on 31/08/2019.
//  Copyright © 2019 Sergio Sánchez Sánchez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var infoImage: UIImageView! {
        didSet {
            infoImage.isUserInteractionEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let infoImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onInfoImageClicked))
        infoImage.addGestureRecognizer(infoImageGestureRecognizer)
    
    }
    
    //Action
    @objc func onInfoImageClicked() {
        
        let alertController = UIAlertController(title: "I Am Rich", message: "Diálogo con información sobre el objetivo del juego", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        
        show(alertController, sender: self)
        
    }
    
}

