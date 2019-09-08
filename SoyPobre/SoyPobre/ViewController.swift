//
//  ViewController.swift
//  SoyPobre
//
//  Created by Sergio Sánchez Sánchez on 08/09/2019.
//  Copyright © 2019 Sergio Sánchez Sánchez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum Status {
        case RICH
        case POOR
    }

    @IBOutlet weak var titleLabel: UIPaddingLabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonView: UIButton!
    
    @IBOutlet weak var onInfoClicked: UIImageView! {
        didSet {
            onInfoClicked.isUserInteractionEnabled = true
        }
    }
    
    private var currentStatus: Status = .POOR
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let infoImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onInfoImageClicked))
        onInfoClicked.addGestureRecognizer(infoImageGestureRecognizer)
    }

    @objc func onInfoImageClicked() {
        
        let imageView = UIImageView(frame: CGRect(x: 10, y: 110, width: 250, height: 250))
        imageView.image = UIImage(named: "author")
        
        let alertController = UIAlertController(title: "Sobre el Autor", message: "Desarrollado por Sergio Sánchez Sánchez para el curso de IOS 12 de cero a profesional", preferredStyle: .alert)
        
        alertController.view.addSubview(imageView)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        
        let height = NSLayoutConstraint(item: alertController.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 420)
        alertController.view.addConstraint(height)

        
        show(alertController, sender: self)
        
    }
    
    @IBAction func onStatusChanged(_ sender: Any) {
        if(self.currentStatus == .POOR) {
            self.currentStatus = .RICH
            self.titleLabel.text = "Soy Rico"
            self.imageView.image = UIImage(named: "rich")
            self.buttonView.setTitle("¡Soy Pobre!", for: .normal)
        } else {
            self.currentStatus = .POOR
            self.titleLabel.text = "Soy Pobre"
            self.imageView.image = UIImage(named: "no_money")
            self.buttonView.setTitle("¡Soy Rico!", for: .normal)
        }
    }
    
    
    
}
